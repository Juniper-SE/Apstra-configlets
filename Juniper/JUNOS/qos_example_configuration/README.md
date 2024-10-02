# QoS (Quality of Service) Configlet for Juniper Apstra

This configlet implements comprehensive QoS settings for Juniper devices managed by Apstra, ensuring optimal traffic management and prioritization in network environments.

## Overview

The configlet performs several key tasks:

1. Configures DSCP and IEEE 802.1p classifiers for incoming traffic
2. Defines code-point aliases for easy reference
3. Sets up forwarding classes and maps them to hardware queues
4. Creates traffic control profiles for different interface speeds
5. Establishes rewrite rules for outgoing traffic
6. Configures scheduler maps and detailed scheduler settings
7. Applies QoS interface settings dynamically to interfaces based on tags

## Usage

1. Download the `qos_example_configlet.json` file from this repository.
2. In Apstra, navigate to Design > Configlets and click "Create Configlet".
3. Choose "Import Configlet" and select the upload the JSON file.
4. Rename the configlet if desired and click "Create".

## Property Set Structure

Create a property set in Apstra with the following YAML structure:

```yaml
scheduler_values:
  AF_transmit_rate_percent: 30
  AF_buffer_size_temporal: 50ms
  AF_priority: low
  BE_transmit_rate: remainder
  BE_buffer_size_temporal: 50ms
  BE_priority: low
  NC_shaping_rate_percent: 5
  NC_buffer_size_percent: 5
  NC_priority: high
  RT_shaping_rate_percent: 30
  RT_buffer_size_temporal: 10ms
  RT_priority: high
```
or

```json
{
  "scheduler_values": {
    "AF_buffer_size_temporal": "4m",
    "AF_priority": "low",
    "AF_transmit_rate_percent": 50,
    "BE_buffer_size_temporal": "4m",
    "BE_priority": "low",
    "BE_transmit_rate": "remainder",
    "NC_buffer_size_percent": 5,
    "NC_priority": "high",
    "NC_shaping_rate_percent": 5,
    "RT_buffer_size_temporal": "5k;",
    "RT_priority": "low-latency",
    "RT_shaping_rate_percent": "50;"
  }
}
```

Adjust the values and add more interfaces as needed for your network configuration.

## Adding Configlet and Property Set to Blueprint

1. Open your blueprint in Apstra.
2. Navigate to Staged > Catalog > Property Sets.
3. Click "Import Property Set" and select the property set you created.
4. Go to Staged > Catalog > Configlets.
5. Click "Import Configlet" and select the QoS configlet.
6. Choose where to apply the configlet (e.g., all switches) and click "Import".

## Applying the Interface Config

1. In the blueprint, go to Staged > Physical > Topology.
2. Select the device you want to configure.
3. Click `Update Link Tags` and add tags that match your traffic control profiles (e.g., "TCP_10G", "TCP_1G").
4. The configlet will automatically apply QoS configurations to tagged interfaces.

## Customization

You can customize the configlet by modifying:

- Classifier mappings
- Code-point aliases
- Forwarding class to queue mappings
- Traffic control profiles
- Rewrite rules
- Scheduler settings

Ensure that any modifications align with your network's QoS requirements and policies.

## Notes

- This configlet assumes a specific QoS strategy. Review and adjust as necessary for your network needs.
- Always test QoS changes in a non-production environment before deploying to live networks.
- Monitor network performance after applying QoS settings to ensure desired outcomes.