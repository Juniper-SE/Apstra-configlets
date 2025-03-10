resource "apstra_configlet" "JUNOS_Mirroring_Session_Remote" {
name = "JUNOS Mirroring Session Remote"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
forwarding-options {
        analyzer {
                MirrorSessionRemote {
                        input {
                                ingress {
                                        interface {{r_input_ingress_if}};
                                }
                                egress {
                                        interface {{r_input_egress_if}};
                                }       
                        }       
                        output {
                                ip-address {{r_output_if}};
                        }
                }
        }
}
EOT

},
]

}