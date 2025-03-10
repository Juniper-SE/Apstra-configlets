resource "apstra_configlet" "NXOS_Software_TCAM_Carving" {
name = "NXOS Software TCAM Carving"
generators = [
{
	config_style = "nxos" 
	section = "system_top" 
	template_text = <<-EOT
hardware access-list tcam region vacl 0
hardware access-list tcam region racl 256
hardware access-list tcam region arp-ether 256 double-wide
EOT
	negation_template_text = <<-EOT
no hardware access-list tcam region arp-ether 256 double-wide
no hardware access-list tcam region racl 256
no hardware access-list tcam region vacl 0
EOT

},
]

}