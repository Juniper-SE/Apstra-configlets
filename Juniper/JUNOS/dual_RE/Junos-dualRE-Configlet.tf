resource "apstra_configlet" "JUNOS_dualRE" {
name = "JUNOS_dualRE"
generators = [
{
	config_style = "junos" 
	section = "top_level_set_delete" 
	template_text = <<-EOT
set system commit synchronize
set groups re0 interfaces em1 unit 0 family inetaddress {{re0_ipv4inet}}
set groups re0 interfaces em1 unit 0 family inetaddress {{re0_ipv4inet_master}} master-only
set groups re1 interfaces em1 unit 0 family inetaddress {{re1_ipv4inet}}
set groups re1 interfaces em1 unit 0 family inetaddress {{re1_ipv4inet_master}} master-only
set chassis redundancy routing-engine 0 master
set chassis redundancy routing-engine 1 backup
set chassis redundancy failover on-loss-of-keepalives
set chassis redundancy failover on-disk-failure
set chassis redundancy graceful-switchover
EOT

},
]

}