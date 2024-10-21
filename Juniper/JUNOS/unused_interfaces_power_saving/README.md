# Unused Interfaces Power Saving Configlet for Apstra

This configlet automatically sets unused interfaces to "unused" status in Juniper Apstra, helping to reduce power consumption in data centre environments.

## Overview

The configlet performs two key tasks:
1. Identifies interfaces that are not part of the active blueprint
2. Sets these interfaces as "unused" to reduce power consumption

## Usage

1. Download the `Unused_Interfaces_Power_Saving.json` file from this repository.
2. In Apstra, navigate to Design > Configlets and click "Create Configlet".
3. Choose "Import Configlet" and select the downloaded JSON file.
4. Rename the configlet if desired and click "Create".

## Configlet Structure

The configlet uses Jinja2 templating to iterate through interfaces and set unused ones to "unused" status. Here's a simplified view of its structure:

```jinja
# Initialise an empty list to store unused interfaces
{% set unused_intfs = [] %}

# Iterate through all interfaces
{% for iface_data in interface.values() %}
    # Skip interfaces that are already in portSetting (these are active interfaces)
    {% if iface_data['intfName'] in portSetting %}
        {% continue %}
    {% endif %}

    # Get port settings for the current interface
    {% set iface_port_settings = iface_data.get('port_setting') or {} %}

    # Check if the interface is a child of a breakout interface
    {% set parent = iface_port_settings.get('interface', {}).get('parent_breakout_interface', [])[:1] %}

    {% if parent %}
        # If it's a child interface and its parent is not in portSetting, add the parent to unused_intfs
        {% if portSetting is defined and parent[0] not in portSetting %}
            {% do unused_intfs.append(parent[0]) %}
        {% endif %}
    {% elif iface_data['is_standalone'] and iface_data['role'] == 'unused' and portSetting is defined and iface_data['intfName'] not in portSetting %}
        # If it's a standalone interface, marked as unused, and not in portSetting, add it to unused_intfs
		{% do unused_intfs.append(iface_data['intfName']) %}
    {% endif %}
{% endfor %}

# Generate the configuration for unused interfaces
{% for intf_name in function.sorted_alphabetical(unused_intfs|unique) %}
    {% if loop.first %}
# Start the interfaces configuration block
interfaces {
    {% endif %}
    # Set each unused interface to 'unused' status
    {{intf_name}} {
        unused;
    }
    {% if loop.last %}
# Close the interfaces configuration block
}
    {% endif %}
{% endfor %}
```

## Compatibility

This configlet is designed for use with Juniper devices running Junos OS Evolved (-EVO). It is not compatible with non-EVO Junos platforms.

Note: This configlet is not compatible with QFX5220 platforms, even though they run EVO.

## Adding Configlet to Blueprint

1. Open your blueprint in Apstra.
2. Go to Staged > Catalog > Configlets.
3. Click "Import Configlet" and select the Unused Interfaces Power Saving configlet.
4. Choose where to apply the configlet (e.g., all leaf switches) and click "Import".

## Applying the Configlet

Once the configlet is added to your blueprint, it will automatically identify unused interfaces and set them to "unused" status when applied.

## Power Savings

Initial testing on a Juniper QFX5240-64O device showed a reduction in power consumption of approximately 4W per unused port. In a test scenario where only one interface was used and 63 were unused, the total power savings were about 255W.

Before applying the configlet:
```
Total Input Power: 760W
```

After applying the configlet:
```
Total Input Power: 505W
```

Note: Actual power savings may vary depending on the specific hardware and configuration of your network devices.