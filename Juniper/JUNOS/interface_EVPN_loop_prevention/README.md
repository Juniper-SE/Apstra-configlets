# Loop Detection for L2 Edge Interfaces Configlet

## Overview

This configlet is a dynamic Jinja-based template designed for Juniper Apstra. It configures enhanced loop detection on standalone L2 edge interfaces. The configlet automatically identifies eligible interfaces and applies the appropriate loop detection settings for each allowed VLAN.

## Functionality

The configlet performs the following actions:

1. Iterates through all interfaces in the device model.
2. Identifies interfaces that meet the following criteria:
   - Role is set to "l2edge"
   - Not part of any aggregated interface (standalone)
   - Has at least one allowed VLAN
3. For each eligible interface, it configures:
   - Enhanced loop detection for each allowed VLAN
   - Loop detection action (interface-down)
   - Transmit interval (1 second)
   - Revert interval (120 seconds)

## Jinja Template

```jinja2
{% for interface_name, interface_data in interface.items() %}
    {% if interface_data.role == "l2edge" and interface_data.part_of == "" and interface_data.allowed_vlans %}
        {% for vlan_id in interface_data.allowed_vlans %}
set protocols loop-detect enhanced interface {{ interface_data.intfName }}.0 vlan-id {{ vlan_id }}
        {% endfor %}
set protocols loop-detect enhanced interface {{ interface_data.intfName }}.0 loop-detect-action interface-down
set protocols loop-detect enhanced interface {{ interface_data.intfName }}.0 transmit-interval 1s
set protocols loop-detect enhanced interface {{ interface_data.intfName }}.0 revert-interval 120s
    {% endif %}
{% endfor %}
```

## Configuration Details

- **Protocol**: Loop Detection (Enhanced)
- **Applicable Interfaces**: Standalone L2 edge interfaces
- **VLAN Configuration**: Applied to each allowed VLAN on the interface
- **Loop Detect Action**: Interface-down
- **Transmit Interval**: 1 second
- **Revert Interval**: 120 seconds

## Usage

This configlet will be automatically applied by Apstra to devices where it's assigned. It uses the device model to dynamically generate the appropriate configuration for each eligible interface.

## Documentation Reference

For more detailed information about the loop detection configuration, please refer to the [Juniper documentation on Loop Detection for EVPN](https://www.juniper.net/documentation/us/en/software/junos/cli-reference/topics/ref/statement/loop-detect-evpn-edit-protocols.html).

## Notes

- This configlet relies on the `interface` data from the device model, which is a hidden and undocumented feature in Apstra.
- Ensure that the roles and VLAN configurations in your Apstra blueprint are correctly set for this configlet to function as intended.
- The configlet will not generate any configuration for interfaces that do not meet all the specified criteria.

## Troubleshooting

If the configlet doesn't generate the expected output:
1. Verify that the interfaces have the correct role ("l2edge") assigned in Apstra.
2. Check that standalone interfaces have an empty "part_of" field in the device model.
3. Ensure that the intended interfaces have at least one allowed VLAN configured.
