# BGP Session Removal Configlet for Apstra

This configlet automates the removal of BGP sessions for decommissioned devices in Juniper Apstra.

## Overview

The configlet performs three key tasks:
1. Identifies devices tagged for decommissioning
2. Locates BGP sessions associated with these devices
3. Generates configuration commands to remove the identified BGP sessions on neighboring devices

## Use Case

This configlet is designed to handle scenarios where a device (e.g., a spine switch) is being decommissioned from the network. When a device is undeployed in Apstra, the BGP sessions on neighboring devices are not automatically removed. This configlet fills that gap by generating the necessary deletion commands for those BGP sessions.

For example, if a spine switch is tagged with 'decomm' and this configlet is applied to all leaf switches, it will create Junos `delete` statements on each leaf switch for every BGP session (both IP and EVPN) that would have faced the decommissioned spine.

## Importing The Configlet

1. Download the `BGP_session_removal.json` file from this repository.
2. In Apstra, navigate to Design > Configlets and click "Create Configlet".
3. Choose "Import Configlet" and select the downloaded JSON file.
4. Rename the configlet if desired and click "Create".

## Configlet

The configlet uses Jinja2 templating to generate the necessary BGP configuration deletions. It performs the following steps:

1. Collects IP addresses of interfaces connected to devices tagged with 'decomm'
2. Identifies BGP sessions associated with these IP addresses
3. Generates BGP configuration deletions for affected sessions on neighboring devices

```jinja
{#
   IMPORTANT: To use this configlet, you must tag the system interfaces
   that are to be decommissioned with the tag 'decomm' in your inventory.
   This configlet will then generate the necessary BGP configuration deletions
   for the tagged interfaces and their corresponding BGP sessions.
#}
 
{# Initialize namespace for storing decommissioned IPs and ASNs #}
{% set ns = namespace(decomm_ips=[], decomm_asn=[]) %}
 
{# Step 1: Collect IP addresses of interfaces tagged with 'decomm' #}
{% for ip_name, ip_data in ip.items() %}
    {% if 'decomm' in ip_data.interface.tags %}
        {# Add the IPv4 address of the tagged interface to our list #}
        {% set ns.decomm_ips = ns.decomm_ips + [ip_data.ipv4_address] %}
    {% endif %}
{% endfor %}
 
{# Step 2: Identify BGP sessions associated with the decommissioned IPs #}
{% for session_name, session_data in bgp_sessions.items() %}
    {% if session_data.source_ip in ns.decomm_ips %}
        {# If the BGP session's source IP matches a decommissioned IP, add its destination ASN to our list #}
        {% set ns.decomm_asn = ns.decomm_asn + [session_data.dest_asn] %}
    {% endif %}
{% endfor %}
 
{# Step 3: Generate BGP configuration deletions for affected sessions #}
{% for session_name, session_data in bgp_sessions.items() %}
    {% if session_data.dest_asn in ns.decomm_asn %}
        {% if session_data.role == 'leaf_evpn' %}
            {# Delete BGP neighbor configuration for EVPN leaf nodes #}
delete protocols bgp group l3clos-l-evpn neighbor {{ session_data.dest_ip }}
        {% elif session_data.role == 'leaf_spine' %}
            {# Delete BGP neighbor configuration for leaf-spine connections #}
delete protocols bgp group l3clos-l neighbor {{ session_data.dest_ip }}
        {% endif %}
    {% endif %}
{% endfor %}
 
{#
   Note: This configlet will generate 'delete' commands for BGP neighbors
   that are connected to interfaces tagged for decommissioning. These commands
   can be applied to remove the BGP peering configurations for the affected devices.
   Always review the generated configuration before applying it to your network.
#}

```

### Adding Configlet to Blueprint

1. Open your blueprint in Apstra.
2. Go to Staged > Catalog > Configlets.
3. Click "Import Configlet" and select the BGP Session Removal configlet.
4. Choose where to apply the configlet (typically all switches that might have BGP sessions with the decommissioned device) and click "Import".

## System Tagging

To use this configlet, you must tag the device that is to be decommissioned with the tag 'decomm' in your blueprint. This is crucial for the configlet to identify which BGP sessions should be removed on neighboring devices.

### Applying the System Tag

1. In the blueprint, go to Staged > Physical > Topology.
2. Select the device you want to decommission (e.g., a spine switch).
3. Click "Update Node Tags" and add the tag "decomm" to the device.
4. The configlet, when applied to other devices (e.g., leaf switches), will automatically generate the necessary BGP configuration deletions for sessions connected to the tagged device.


Note: Always review the generated configuration before applying it to your network to ensure it aligns with your decommissioning plans. This configlet should be used as part of a carefully planned decommissioning process.