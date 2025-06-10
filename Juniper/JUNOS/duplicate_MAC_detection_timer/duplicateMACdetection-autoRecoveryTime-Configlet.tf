resource "apstra_configlet" "junos_duplicateMACdetection" {
name = "junos-duplicateMACdetection"
generators = [
{
	config_style = "junos" 
	section = "top_level_set_delete" 
	template_text = <<-EOT
set protocols evpn duplicate-mac-detection auto-recovery-time 22
EOT

},
]

}