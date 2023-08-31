This directory of configlets can be used to deploy OISM with JUNOS and Apstra. 

### Basic setup ###
Here is an example network topology:

![OISM_netowork_topology.png](images/OISM_netowork_topology.png)

1. For basic configuration you will need to name the VLANs appropriately:
![basic_configuration.png](images/basic_configuration.png)

2. Next provision the SBD VLAN:
![SBD_provisioning.png](images/SBD_provisioning.png)

3. We use a property set to assign values needed for external connectivity:
![property_set.png](images/property_set.png)

4. Next create the two configlets (you can import the json here or copy and paste) Make sure you assign them to the correct devices via tags or manually via the Apstra UI.
![create_configlets_and_assign.png](images/create_configlets_and_assign.png)

Here is an example of the resulting generated configurations from the configlets:
![config_generated.png](images/config_generated.png)

### Border leaf connectivity to Multicast gateway ###
Here is an example of a pair of border leaf devices connectivity to an upstream MCAST gateway:
![OISM_border_leaf_design.png](images/OISM_border_leaf_design.png)

1. To provision the MVLAN on the border leafs follow the following steps:
![border_mvlan_provisioning.png](images/border_mvlan_provisioning.png)

2. Next, you will need a connectivity template for the multicast router to peer with the border leaf over BGP, and Assign it to the correct Aggregated interface (in this case):
![mc_router_connectivity_template.png](images/mc_router_connectivity_template.png)

3. Now update the property set with the correct IP Addresses: 
![update_property_set_for_mc_router.png](images/update_property_set_for_mc_router.png)

### Multicast gateway example configuration ###

Here is an example multicast router configuration:
![mc_router_example_config.png](images/mc_router_example_config.png)

### Inter-VRF Multicast routing ###

1. If you want inter-vrf multicast routing you will need to make a few additional changes, here is an example diagram:
![inter_vrf_mcast_routing.png](images/inter_vrf_mcast_routing.png)

2. Make the following modifications to your setup to add the additional elements, including Connectivity Template Additions:
![inter_vlan_mc_routing_edits.png](images/inter_vlan_mc_routing_edits.png)

3. Modify the property set to enable the additional VRFs. 
![inter_vlan_prop_set_update.png](images/inter_vlan_prop_set_update.png)

Here is the rendered configuration for the border leaf:
![inter_vrf_border_leaf.png](images/inter_vrf_border_leaf.png)

The rendered server leaf configuration:
![inter_vlan_server_leaf.png](images/inter_vlan_server_leaf.png)

And added changes to the Multicast gateway configuration: 
![inter_vlan_mc_router_add_config.png](images/inter_vlan_mc_router_add_config.png)

### Additional Resources ### 
Here is the [Juniper Tech publication about OISM with EVPN and VXLAN](https://www.juniper.net/documentation/us/en/software/junos/evpn-vxlan/topics/topic-map/oism-evpn-vxlan.html).