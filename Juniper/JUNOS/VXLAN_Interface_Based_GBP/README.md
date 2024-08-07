# VXLAN Group-Based Policy (GBP) Configlet for Apstra

This configlet implements VXLAN Group-Based Policy (GBP) for micro-segmentation in data centre environments using Juniper Apstra.

## Overview

The configlet performs three key tasks:
1. Enables VXLAN GBP
2. Creates firewall filters defining communication rules between Scalable Group Tags (SGTs)
3. Applies GBP firewall filter policies to specific ports

## Usage

1. Download the `VXLAN_Interface_Based_GBP.json` file from this repository.
2. In Apstra, navigate to Design > Configlets and click "Create Configlet".
3. Choose "Import Configlet" and select the downloaded JSON file.
4. Rename the configlet if desired and click "Create".

## Property Set Structure

Create a property set in Apstra with the following YAML structure (or JSON) as found in the exmaples provided in this repository:

```yaml
gbp_info:
  - '10':
    - '10': accept
    - '20': accept
    - '30': discard
  - '20':
    - '20': accept
    - '10': accept
    - '30': discard
  - '30':
    - '10': discard
    - '20': discard
    - '30': accept
```

Replace the numbers and actions with your desired SGT values and policies.

## Adding Configlet and Property Set to Blueprint

Open your blueprint in Apstra.
Navigate to Staged > Catalog > Property Sets.
Click "Import Property Set" and select the property set you created.
Go to Staged > Catalog > Configlets.
Click "Import Configlet" and select the GBP configlet.
Choose where to apply the configlet (e.g., all leaf switches) and click "Import".

## Applying the Configlet

In the blueprint, go to Staged > Physical > Topology.
Select the generic system you want to tag.
Click "Update Node Tags" and add tags in the format "gbp_<SGT>" (e.g., "gbp_10").
The configlet will automatically apply GBP configurations to tagged interfaces.
