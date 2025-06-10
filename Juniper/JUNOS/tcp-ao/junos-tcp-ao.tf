resource "apstra_configlet" "junos_tcp_ao" {
name = "junos-tcp-ao"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
security {
    authentication-key-chains {
        key-chain JPW-Chain {
            key 0 {
                secret "$9$MjEL7Vji.m5FDik.PfzFcyrvX7"; ## SECRET-DATA
                start-time "2022-3-23.16:45:00 +0000";
                algorithm ao;
                ao-attribute {
                    send-id 0;
                    recv-id 0;
                    tcp-ao-option enabled;
                    cryptographic-algorithm aes-128-cmac-96;
                }
            }
        }
    }
}
EOT

},
{
	config_style = "junos" 
	section = "top_level_set_delete" 
	template_text = <<-EOT
set protocols bgp group l3clos-l-evpn authentication-algorithm ao
set protocols bgp group l3clos-l-evpn authentication-key-chain JPW-Chain
EOT

},
]

}