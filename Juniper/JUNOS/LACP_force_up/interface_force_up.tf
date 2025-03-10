resource "apstra_configlet" "Junos_Interface_Force_Up" {
name = "Junos Interface Force Up"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
ether-options {
         802.3ad {
               lacp {
                force-up;
                }
         }
}
EOT

},
]

}