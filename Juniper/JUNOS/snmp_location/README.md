# SNMP Location for Abstract Configlets

This configlet demonstrates how to reference the location field set under 'Manage Devices' within an SNMP configlet or any configlet that may benefit from location information in Juniper Apstra.

The configlet is a [dynamic jinja-based template](https://supportportal.juniper.net/s/article/Juniper-Apstra-Jinja-Configlets-using-dynamic-data-from-deviceModel?language=en_US).


## Overview

The configlet performs two key tasks:
1. Sets up a basic SNMP configuration
2. Demonstrates how to reference the location field within the configlet

## Usage

1. Download the `snmpLocation_jinja.json` file from this repository.
2. In Apstra, navigate to Design > Configlets and click "Create Configlet".
3. Choose "Import Configlet" and select the downloaded JSON file.
4. Rename the configlet if desired and click "Create".

## Configlet Structure

```
snmp {
    community public;
    location {{ location }};
}
```

This configlet sets up a basic SNMP configuration with a public community string and references the location field using the `{{ location }}` variable.

## Setting Device Location

To set the location for a particular device:

1. Go to Manage Devices in Apstra.
2. Select the device you wish to view.
![Screenshot 2024-10-18 at 11 58 00](https://github.com/user-attachments/assets/6be204f7-037e-4ff7-96d4-664e639d795b)

3. In the first tab (Devices), click the "Edit" button on the right-hand side.
![Screenshot 2024-10-18 at 11 58 19](https://github.com/user-attachments/assets/6d0ed288-0eb5-456b-837a-8c1cb1d47b65)

4. You will see a "Location" field. Click "Edit" to add your desired XYZ location.
![Screenshot 2024-10-18 at 11 32 27](https://github.com/user-attachments/assets/19a5aba2-420e-4152-a93e-508e71391253)


## Adding Configlet to Blueprint

1. Open your blueprint in Apstra.
2. Go to Staged > Catalog > Configlets.
3. Click "Import Configlet" and select the SNMP Location configlet.
4. Choose where to apply the configlet (e.g., all switches) and click "Import".

## Applying the Configlet

Once the configlet is added to your blueprint and you've set the location for your devices, the configlet will automatically reference the location you've set when it's applied.

Note: This configlet serves as an example of how to use the location field. You can incorporate the `{{ location }}` reference into other configlets where location information is relevant.
