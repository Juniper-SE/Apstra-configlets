This firewall filter protects Leaf/Spine devices routing-engines.
It is taking care of specifically allowing :
  - BFD
  - BGP
  - SNMP
  - NTP
  - ICMP
  - TRACEROUTE
  - SSH
  - NETCONF
  - HTTP/HTTPS for Leaf/Spine upgrade via Apstra GUI
  - TACACS
  - DHCP relay

And denying anything else.

BE CAREFUL, on QFX5k mainly, the TCAM size is limited and its limit can be reached "easily" if this happens, make sure the FW filter is optimized (i.e. for example, in the associated prefix-list, try to use supernets to limit the number of entries in the TCAM)
