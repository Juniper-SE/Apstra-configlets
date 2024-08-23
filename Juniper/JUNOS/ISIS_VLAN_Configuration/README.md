# Apstra ISIS Configlet

This configlet is designed to configure ISIS (Intermediate System to Intermediate System) routing protocol on Juniper devices managed by Apstra. It specifically targets VLANs with a VXLAN ID of 300000.

## Functionality

The configlet performs the following actions:

1. Configures the ISO family on the IRB (Integrated Routing and Bridging) interface for the specified VLAN.
2. Sets up an ISO address on the loopback interface (lo0).
3. Enables ISIS on the IRB interface.
4. Configures the loopback interface for ISIS:
   - Disables Level 1 routing
   - Sets Level 2 as passive
5. Globally configures ISIS:
   - Disables Level 1 routing
   - Enables wide metrics for Level 2
   - Enables the ISIS protocol

## How It Works

This configlet uses Jinja2 templating to iterate through the VLANs defined in the Apstra blueprint. When it finds a VLAN with a VXLAN ID of 300000, it applies the ISIS configuration to that VLAN's IRB interface and sets up the global ISIS settings.

## Usage

To use this configlet in Apstra:

1. Import the .json configlet into Apstra (Design > Configlets > New Configlet > Import).
2. Import the configlet into your blueprint.
3. Apply the configlet to the appropriate device role or device in your Apstra blueprint.
4. Commit and deploy your changes.

## Notes

- This configlet assumes that you want to run ISIS only at Level 2, with Level 1 disabled.
- The ISO address is hardcoded to `49.0001.1720.2700.0003.00`. Modify this if a different address is required.
- Ensure that the VLAN with VXLAN ID 300000 exists in your blueprint for this configlet to take effect.

## Customization

You may need to adjust the VXLAN ID or other parameters to match your specific network design. Always review and test the configlet in a non-production environment before deploying to production devices.
