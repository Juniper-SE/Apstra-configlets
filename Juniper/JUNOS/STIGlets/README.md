
## STIG Configlets ##

This is a series of Apstra configlets meant to meet various STIG requirements for JUNOS devices. These are examples on how to meet the various requirements and will need to be tailored to your environment.  Credit to Dave Potts for the original configlets. These have all been tested on Apstra 4.1 and vQFX 20.2R1.10. The JSON file has 3 property sets - One for the BGP keys, one for snmpv3 passwords, and one for everything else. SNMPv3 has to be split into 2 configlets(general config and password) and the password has to be passed as plain text because the password hashes are device unique and not transferable.

* STIG_bgp_auth
  * Creates apply group to enable key chain authentication for all bgp sessions
  * apply to superspine, spine and leaf
* STIG_dhcp_security
  * Enables dhcp snooping, arp inspection and ip source guard for all vlans
  * apply to leaf
* STIG_disable_unused_int
  * Creates a dead vlan, disables unused interfaces and puts them as access ports in the dead vlan
  * apply to leaf
* STIG_disk_monitor
  * Creates syslog alerts for high disk utilization of /var
  * apply to all devices
* STIG_login
  * Adds login message, sets password complexity requirements, create login classes, and sets emergency account and password
  * apply to all devices
* STIG_multicast
  * enables igmp-snooping and mdl-snooping on all
  * apply to leaf
* STIG_ntp
  * Configures ntp servers and authentication
  * management_ip is device context, not property set. Do not create it in a property set
  * apply to all devices
* STIG_protect_re
  * creates protect_re policy and applies it to lo0
  * mgmt_network is a comma separated list without quotes
  * apply to all devices
* STIG_snmpv3_config
  * Applies snmpv3 config minus passwords. Passwords must be a seperate configlet pushed after this one
  * apply to all devices
* STIG_snmpv3_pass
  * applies snmpv3 password to switch in plaintext. Cannot use hashed values because they are only valid for the switch it was created on.
  * apply to all devices
* STIG_ssh
  * applies required ssh configs
  * apply to all devices
* STIG_storm_control
  * Creates storm control profile and applies it to edge interfaces
  * apply on leaf
* STIG_syslog
  * sets timezone, creates required log files, security log archival, and syslog server
  * apply to all devices
