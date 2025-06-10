resource "apstra_configlet" "OISM_Server_Leaf" {
name = "OISM-Server-Leaf"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
{# OISM Configlet for Apstra 4.2 #}
{# by Tony Chan <tonychan@juniper.net> #}
{# https://www.juniper.net/documentation/us/en/software/junos/evpn-vxlan/topics/topic-map/oism-evpn-vxlan.html #}


{# Enable OISM globally (common)#}
{% if bgpService.evpn_uses_mac_vrf %}
routing-instances {
    evpn-1 {
{% endif %}        
        forwarding-options {
            multicast-replication {
                evpn {
                    irb oism;
                }
            }
        }
{% if bgpService.evpn_uses_mac_vrf %}
    }
}
{% endif %}


{# Config SBD IRB and PIM on all revenue interfaces of the associated VRF(common) #}
{# SBD VLAN and IRB will be configured by Apstra virtual network constructs #}
{% for v in (vlan |d({})).values() if v.get('name', '').endswith('-SBD') %}
{% if loop.first %}
routing-instances {
{% endif %}
    {{ v.vrf_name }} {
        protocols {
            evpn {
                oism {
                    supplemental-bridge-domain-irb irb.{{ v.id }};
                }
            }
            pim {
                passive;
                interface all;
                interface irb.{{ v.id }} {
                    accept-remote-source;
                }
            }
            ospf {
                area 0.0.0.0 {
                    interface irb.{{ v.id }};
                    interface {{ security_zones[v.vrf_name]['loopback_intf']}};
                }
            }
        }
    }
{% if loop.last -%}
}
{% endif %}
{% endfor %}

{# Enable IGMP Snooping #}
{% for v in (vlan |d({})).values() if v.get('name', '').endswith('-SBD') %}
{% if loop.first %}
{% if bgpService.evpn_uses_mac_vrf %}
routing-instances {
    evpn-1 {
{% endif %}
        protocols {
            igmp-snooping {
{% endif %}
{% for v1 in (vlan |d({})).values() if v1.get('vrf_name', '') == v['vrf_name'] and v1['impl_type'] == 'vxlan'%}
                vlan vn{{ v1.id }} {
                    proxy;
                }
{% endfor %}
{% if loop.last %}
            }
        }
{% if bgpService.evpn_uses_mac_vrf %}
    }
}
{% endif %}
{% endif %}
{% endfor %}

{# Enable IGMP  #}
{% for v in (vlan |d({})).values() if v.get('name', '').endswith('-SBD') %}
{% if loop.first %}
protocols {
    igmp {
{% endif %}
{% for v1 in (vlan |d({})).values() if v1.get('vrf_name', '') == v['vrf_name'] and v1['impl_type'] == 'vxlan'%}
        interface irb.{{ v1.id }};
{% endfor %}
{% if loop.last %}
    }
}
{% endif %}
{% endfor %}

{# Enable install-star-g-routes on QFX10K and PTX (required)#}
{# https://www.juniper.net/documentation/us/en/software/junos/evpn-vxlan/topics/topic-map/oism-evpn-vxlan.html #}
{% if hcl.startswith('Juniper_QFX1000') or hcl.startswith('Juniper_PTX')%}
multicast-snooping-options {
    oism {
        install-star-g-routes;
    }
}
{% endif %}

{# Enable conserve-mcast-routes-in-pfe for QFX5130/QFX5700 (required)#}
{# https://www.juniper.net/documentation/us/en/software/junos/evpn-vxlan/topics/topic-map/oism-evpn-vxlan.html #}
{% if hcl.startswith('Juniper_QFX5130') or hcl.startswith('Juniper_QFX5700')%}
multicast-snooping-options {
    oism {
        conserve-mcast-routes-in-pfe;
    }
}
{% endif %}
EOT

},
]

}