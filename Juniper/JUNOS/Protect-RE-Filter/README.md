This firewall filter protects Leaf/Spine devices routing-engines. It should be created as a junos/hierarchical configlet in Apstra

It is taking care denying any traffic except the following :
  - BFD
  - BGP
  - SNMP
  - NTP
  - DNS
  - ICMP
  - TRACEROUTE
  - SSH
  - NETCONF
  - HTTP/HTTPS for Leaf/Spine upgrade via Apstra GUI
  - TACACS and RADIUS (keep the needed one)
  - PIM
  - DHCP relay

BE CAREFUL, on QFX5k mainly, the TCAM size is limited and its limit can be reached "easily". If this happens, make sure the FW filter is optimized (i.e. for example, in the associated prefix-list, try to use supernets to limit the number of entries in the TCAM: 1.1.1.0/30 is better than 1.1.1.1/32 + 1.1.1.2/32)
