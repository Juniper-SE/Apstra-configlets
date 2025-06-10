resource "apstra_configlet" "Dynamic_QoS_Example_Configlet" {
name = "Dynamic QoS Example Configlet"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
{# This configlet defines comprehensive QoS (Quality of Service) settings for Juniper devices #}
system {
    packet-forwarding-options {
        no-ip-tos-rewrite;
        {# Disables rewriting of IP ToS (Type of Service) field #}
    }
}

class-of-service {
    {# Classifiers map incoming traffic to forwarding classes based on DSCP or IEEE 802.1p values #}
    classifiers {
        dscp cl-dscp-in {
            {# DSCP classifier for incoming traffic #}
            forwarding-class fc-assured-forwarding {
                loss-priority high code-points af21;
                loss-priority low code-points af41;
            }
            forwarding-class fc-best-effort {
                loss-priority low code-points be;
            }
            forwarding-class fc-network-control {
                loss-priority low code-points [ nc1 nc2 ];
            }
            forwarding-class fc-real-time {
                loss-priority low code-points ef;
            }
        }
        ieee-802.1 cl-8021p-in {
            {# IEEE 802.1p classifier for incoming traffic #}
            forwarding-class fc-assured-forwarding {
                loss-priority high code-points af21;
                loss-priority low code-points af41;
            }
            forwarding-class fc-best-effort {
                loss-priority high code-points be;
            }
            forwarding-class fc-network-control {
                loss-priority low code-points [ nc1 nc2 ];
            }
            forwarding-class fc-real-time {
                loss-priority low code-points ef;
            }
        }
    }

    {# Code-point aliases for easier reference of DSCP and IEEE 802.1p values #}
    code-point-aliases {
        dscp {
            {# DSCP code point aliases #}
            af11 001010;
            af12 001100;
            af13 001110;
            af21 010010;
            af22 010100;
            af23 010110;
            af31 011010;
            af32 011100;
            af33 011110;
            af41 100010;
            af42 100100;
            af43 100110;
            be 000000;
            cs1 001000;
            cs2 010000;
            cs3 011000;
            cs4 100000;
            cs5 101000;
            cs6 110000;
            cs7 111000;
            ef 101110;
            nc1 110000;
            nc2 111000;
        }
        ieee-802.1 {
            {# IEEE 802.1p code point aliases #}
            af21 010;
            af31 011;
            af41 100;
            be 000;
            cs1 001;
            cs2 010;
            cs3 011;
            cs4 100;
            ef 101;
            nc1 110;
            nc2 111;
        }
    }

    {# Configuration for traffic originating from the device itself #}
    host-outbound-traffic {
        forwarding-class fc-network-control;
        ieee-802.1 {
            default nc1;
        }
    }

    {# Drop profile definition for queue management #}
    drop-profiles {
        DP-TAIL {
            fill-level 0 drop-probability 0;
            fill-level 100 drop-probability 100;
        }
    }

    {# Mapping of forwarding classes to hardware queues #}
    forwarding-classes {
        class fc-assured-forwarding queue-num 4;
        class fc-best-effort queue-num 0;
        class fc-network-control queue-num 7;
        class fc-real-time queue-num 5;
    }

    {# Traffic control profiles for different interface speeds and scenarios #}
    traffic-control-profiles {
        TCP_10G {
            scheduler-map sm-pqos;
            shaping-rate 10g;
        }
        TCP_10G_Remaining {
            scheduler-map sm-pqos;
            shaping-rate 10g;
        }
        TCP_10G_overheads {
            scheduler-map sm-pqos;
            shaping-rate 9800000000;
        }
        TCP_1G {
            scheduler-map sm-pqos;
            shaping-rate 1g;
        }
        TCP_1G_Remaining {
            scheduler-map sm-pqos;
            shaping-rate 1g;
        }
        TCP_1G_overheads {
            scheduler-map sm-pqos;
            shaping-rate 980m;
        }
    }

    {# Rewrite rules for modifying DSCP and IEEE 802.1p values on egress #}
    rewrite-rules {
        dscp rr-dscp-out {
            {# DSCP rewrite rules #}
            forwarding-class fc-assured-forwarding {
                loss-priority high code-point af21;
                loss-priority low code-point af41;
            }
            forwarding-class fc-best-effort {
                loss-priority low code-point be;
            }
            forwarding-class fc-network-control {
                loss-priority low code-point nc1;
            }
            forwarding-class fc-real-time {
                loss-priority low code-point ef;
            }
        }
        ieee-802.1 rr-8021p-out {
            {# IEEE 802.1p rewrite rules #}
            forwarding-class fc-assured-forwarding {
                loss-priority high code-point af21;
                loss-priority low code-point af41;
            }
            forwarding-class fc-best-effort {
                loss-priority low code-point be;
            }
            forwarding-class fc-network-control {
                loss-priority low code-point nc1;
            }
            forwarding-class fc-real-time {
                loss-priority low code-point ef;
            }
        }
    }

    {# Scheduler map linking forwarding classes to schedulers #}
    scheduler-maps {
        sm-pqos {
            forwarding-class fc-assured-forwarding scheduler sc-assured-forwarding;
            forwarding-class fc-best-effort scheduler sc-best-effort;
            forwarding-class fc-network-control scheduler sc-network-control;
            forwarding-class fc-real-time scheduler sc-real-time;
        }
    }

    {# Scheduler configurations for each forwarding class #}
    schedulers {
        sc-assured-forwarding {
            transmit-rate percent {{scheduler_values.AF_transmit_rate_percent}};
            buffer-size temporal {{scheduler_values.AF_buffer_size_temporal}};
            priority {{scheduler_values.AF_priority}};
        }
        sc-best-effort {
            transmit-rate {
                {{scheduler_values.BE_transmit_rate}};
            }
            buffer-size temporal {{scheduler_values.BE_buffer_size_temporal}};
            priority {{scheduler_values.BE_priority}};
        }
        sc-network-control {
            shaping-rate percent {{scheduler_values.NC_shaping_rate_percent}};
            buffer-size percent {{scheduler_values.NC_buffer_size_percent}};
            priority {{scheduler_values.NC_priority}};
        }
        sc-real-time {
            shaping-rate percent {{scheduler_values.RT_shaping_rate_percent}};
            buffer-size temporal {{scheduler_values.RT_buffer_size_temporal}};
            priority {{scheduler_values.RT_priority}};
        }
    }

{# Jinja loop to generate interface configurations based on provided parameters #}
{% for int_name, int_params in interface.items() %}
    {% for tag in int_params["tags"] %}
        {# If the interface has a tag that starts with 'TCP_' then the interface config will be rendered and the tag name used #}
        {% if "TCP_" in tag|upper %}
    interfaces {
        {{int_params["intfName"]}} {
            output-traffic-control-profile {{tag|upper}};
            unit 0 {
                classifiers {
                    dscp cl-dscp-in;
                    ieee-802.1 cl-8021p-in;
                }
                rewrite-rules {
                    dscp rr-dscp-out;
                    ieee-802.1 rr-8021p-out;
                }
            }
        }
    }
        {% endif %}
    {% endfor %} 
{% endfor %}

}
EOT

},
]

}