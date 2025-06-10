resource "apstra_configlet" "MAC_move_suppression" {
name = "MAC_move_suppression"
generators = [
{
	config_style = "junos" 
	section = "top_level_set_delete" 
	template_text = <<-EOT
set protocols evpn duplicate-mac-detection detection-threshold 6 detection-window 180 auto-recovery-time 5
EOT

},
]

}