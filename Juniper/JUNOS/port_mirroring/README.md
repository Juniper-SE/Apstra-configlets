These configlets and property sets are used to set up local and remote session mirroring.
[Juniper Documentation for Port Mirroring](https://www.juniper.net/documentation/us/en/software/junos/network-mgmt/topics/topic-map/port-mirroring-local-and-remote-analysis.html#id-configuring-port-mirroring-s)
## Remote port mirroring stanza:
```
    forwarding-options {
        analyzer {
                MirrorSessionRemote {
                        input {
                                ingress {
                                        interface {{r_input_ingress_if}};
                                }
                                egress {
                                        interface {{r_input_egress_if}};
                                }       
                        }       
                        output {
                                ip-address {{r_output_if}};
                        }
                }
        }
}
property set variables
r_output_if is some IP address (10.250.0.1)
r_input_ingress_if is some Interface (xe-0/0/5.0)
r_input_egress_if is some Interface (xe-0/0/5.0)
```
## Local port mirroring stanza:
```
    forwarding-options {
        analyzer {
                MirrorSessionRemote {
                        input {
                                ingress {
                                        interface {{r_input_ingress_if}};
                                }
                                egress {
                                        interface {{r_input_egress_if}};
                                }       
                        }       
                        output {
                                ip-address {{r_output_if}};
                        }
                }
        }
}
property set variables:
output_if is some interface (xe-0/0/10.0)
input_egress_if (xe-0/0/5.0)
input_ingress_if (xe-0/0/5.0)
