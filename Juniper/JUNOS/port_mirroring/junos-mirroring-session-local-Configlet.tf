resource "apstra_configlet" "JUNOS_Mirroring_Session_Local" {
name = "JUNOS Mirroring Session Local"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
forwarding-options {
    analyzer {
        MirrorSessionLocal {
            input {
                ingress {
                    interface {{input_ingress_if}};
                }
                egress {
                    interface {{input_egress_if}};
                }
            }
            output {
                interface {{output_if}};
            }
        }
    }
}
EOT

},
]

}