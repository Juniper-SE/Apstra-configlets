resource "apstra_configlet" "DDOS_vxlan_protection" {
name = "DDOS_vxlan_protection"
generators = [
{
	config_style = "junos" 
	section = "top_level_set_delete" 
	template_text = <<-EOT
set system ddos-protection protocols vxlan aggregate bandwidth 1000
set system ddos-protection protocols vxlan aggregate burst 400
EOT

},
]

}