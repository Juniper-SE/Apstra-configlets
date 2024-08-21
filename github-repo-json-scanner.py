"""
Apstra Configlet Validation Script

This script is used to check if all configlets in the specified GitHub repository 
can be imported into Apstra without issues. It's particularly useful for validating 
configlets against new versions of Apstra.

High-level functionality:
1. Cleans up any existing configlets in the Apstra instance
2. Clones the specified GitHub repository containing configlets
3. Processes each JSON file in the repository:
   - Validates the JSON structure
   - Attempts to post the configlet to Apstra
   - Deletes the posted configlet if successful
4. Generates a comprehensive report of the operations
5. Optionally deletes the cloned repository

This script helps identify any configlets that may have compatibility issues
with the current Apstra version, ensuring smooth upgrades and maintenance.

by Adam Jarvis
"""

import os
import subprocess
import json
from pathlib import Path
import shutil
import requests
import urllib3

# Disable warnings about insecure HTTPS requests
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Configuration variables
API_IP = "x.x.x.x"
USERNAME = "admin"
PASSWORD = "admin"

API_BASE_URL = f"https://{API_IP}"
LOGIN_ENDPOINT = f"{API_BASE_URL}/api/aaa/login"
CONFIGLETS_ENDPOINT = f"{API_BASE_URL}/api/design/configlets"

def cleanup_previous_run(target_dir, report_file):
    # Remove the cloned repo directory if it exists
    if os.path.exists(target_dir):
        try:
            shutil.rmtree(target_dir)
            print(f"Removed existing directory: {target_dir}")
        except Exception as e:
            print(f"Error removing directory {target_dir}: {e}")

    # Remove the report file if it exists
    if os.path.exists(report_file):
        try:
            os.remove(report_file)
            print(f"Removed existing report file: {report_file}")
        except Exception as e:
            print(f"Error removing file {report_file}: {e}")

def clone_repo(repo_url, target_dir):
    subprocess.run(["git", "clone", repo_url, target_dir], check=True)

def find_json_files(directory):
    json_files = []
    for root, dirs, files in os.walk(directory):
        if root == directory:  # Skip the root directory
            continue
        for file in files:
            if file.endswith('.json'):
                json_files.append(os.path.join(root, file))
    return json_files

def login():
    login_data = {
        "username": USERNAME,
        "password": PASSWORD
    }
    try:
        response = requests.post(LOGIN_ENDPOINT, json=login_data, verify=False)
        response.raise_for_status()
        return response.json().get('token')
    except requests.RequestException as e:
        print(f"Login failed: {str(e)}")
        return None

def get_all_configlets(token):
    headers = {"authtoken": f"{token}"}
    try:
        response = requests.get(CONFIGLETS_ENDPOINT, headers=headers, verify=False)
        response.raise_for_status()
        return response.json().get('items', [])
    except requests.RequestException as e:
        print(f"Failed to get configlets: {str(e)}")
        return []

def delete_all_configlets(token):
    configlets = get_all_configlets(token)
    headers = {"authtoken": f"{token}"}
    for configlet in configlets:
        try:
            response = requests.delete(f"{CONFIGLETS_ENDPOINT}/{configlet['id']}", headers=headers, verify=False)
            response.raise_for_status()
            print(f"Deleted configlet: {configlet['display_name']}")
        except requests.RequestException as e:
            print(f"Failed to delete configlet {configlet['display_name']}: {str(e)}")

def post_to_api(file_path, token):
    try:
        with open(file_path, 'r') as file:
            try:
                data = json.load(file)
            except json.JSONDecodeError as json_error:
                return None, f"JSON Decode Error in file {file_path}: {str(json_error)}"
    except IOError as io_error:
        return None, f"IO Error reading file {file_path}: {str(io_error)}"

    if not data:
        return None, f"Empty JSON file: {file_path}"

    # Check for required keys in the JSON structure
    if 'ref_archs' not in data or 'generators' not in data:
        return None, f"Invalid JSON structure in file {file_path}: Missing 'ref_archs' or 'generators' key"

    headers = {"authtoken": f"{token}"}
    try:
        response = requests.post(CONFIGLETS_ENDPOINT, json=data, headers=headers, verify=False)
        response.raise_for_status()
        return response.json().get('id'), None  # Assuming the API returns an 'id' field
    except requests.RequestException as e:
        return None, f"API Error for file {file_path}: {str(e)}: {response.text if 'response' in locals() else 'No response'}"

def delete_configlet(configlet_id, token):
    headers = {"authtoken": f"{token}"}
    try:
        response = requests.delete(f"{CONFIGLETS_ENDPOINT}/{configlet_id}", headers=headers, verify=False)
        response.raise_for_status()
        return True, None
    except requests.RequestException as e:
        return False, f"{str(e)}: {response.text if 'response' in locals() else 'No response'}"

def process_json_files(files, token):
    results = []
    for file in files:
        configlet_id, error = post_to_api(file, token)
        if configlet_id:
            delete_success, delete_error = delete_configlet(configlet_id, token)
            if delete_success:
                results.append({"file": file, "status": "success", "configlet_id": configlet_id, "deleted": True})
            else:
                results.append({"file": file, "status": "partial", "configlet_id": configlet_id, "deleted": False, "delete_error": delete_error})
        else:
            if "JSON Decode Error" in error or "Empty JSON file" in error or "IO Error reading file" in error or "Invalid JSON structure" in error:
                results.append({"file": file, "status": "skipped", "error": error})
            else:
                results.append({"file": file, "status": "failed", "error": error})
    return results

def generate_report(results):
    successes = [r for r in results if r['status'] == 'success']
    partials = [r for r in results if r['status'] == 'partial']
    failures = [r for r in results if r['status'] == 'failed']
    skipped = [r for r in results if r['status'] == 'skipped']
    
    report = "API Post and Delete Report\n\n"
    report += "===========================\n\n"
    report += f"Total files processed: {len(results)}\n"
    report += f"Successful posts and deletes: {len(successes)}\n"
    report += f"Successful posts but failed deletes: {len(partials)}\n"
    report += f"Failed posts: {len(failures)}\n"
    report += f"Skipped files: {len(skipped)}\n\n"
    
    report += "Successful Posts and Deletes:\n\n"
    report += "=============================\n"
    for s in successes:
        report += f"File: {s['file']}\n"
        report += f"Configlet ID (deleted): {s['configlet_id']}\n\n"
    
    report += "Successful Posts but Failed Deletes:\n\n"
    report += "=====================================\n"
    for p in partials:
        report += f"File: {p['file']}\n"
        report += f"Configlet ID: {p['configlet_id']}\n"
        report += f"Delete Error: {p['delete_error']}\n\n"
    
    report += "Failed Posts:\n\n"
    report += "=============\n"
    for f in failures:
        report += f"File: {f['file']}\n"
        report += f"Error: {f['error']}\n\n"

    report += "Skipped Files:\n\n"
    report += "==============\n"
    for s in skipped:
        report += f"File: {s['file']}\n"
        report += f"Error: {s['error']}\n\n"
    
    return report

def ask_to_delete(directory):
    while True:
        response = input(f"Do you want to delete the cloned directory '{directory}'? (yes/no): ").lower()
        if response in ['yes', 'y']:
            try:
                shutil.rmtree(directory)
                print(f"Directory '{directory}' has been deleted.")
            except Exception as e:
                print(f"Error deleting directory: {e}")
            return
        elif response in ['no', 'n']:
            print(f"Directory '{directory}' has been kept.")
            return
        else:
            print("Please answer 'yes' or 'no'.")

def main():
    repo_url = "https://github.com/Juniper-SE/Apstra-configlets"
    target_dir = "Apstra-configlets"
    report_file = "api_post_delete_report.txt"

    # Clean up from previous runs
    cleanup_previous_run(target_dir, report_file)

    # Step 1: Login
    token = login()
    if not token:
        print("Failed to login. Exiting.")
        return

    # Step 2: Delete all existing configlets
    print("Deleting all existing configlets...")
    delete_all_configlets(token)

    # Step 3: Clone the repository
    clone_repo(repo_url, target_dir)

    # Step 4: Find all JSON files and create a list (excluding root directory)
    json_files = find_json_files(target_dir)

    # Step 5: Process JSON files, post to API, and delete if successful
    results = process_json_files(json_files, token)

    # Step 6: Generate report
    report = generate_report(results)

    # Step 7: Print and save report
    print("\nReport:")
    print(report)
    with open(report_file, "w") as report_file_handle:
        report_file_handle.write(report)
    print(f"\nReport saved as '{report_file}'")

    # Step 8: Ask if the user wants to delete the cloned directory
    ask_to_delete(target_dir)

if __name__ == "__main__":
    main()