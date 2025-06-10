resource "apstra_configlet" "QFX10K_HashingFix" {
name = "QFX10K-HashingFix"
generators = [
{
	config_style = "junos" 
	section = "top_level_set_delete" 
	template_text = <<-EOT
set forwarding-options hash-key family inet layer-4
EOT

},
]

}