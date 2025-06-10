resource "apstra_configlet" "disableUnusedInterfaces" {
name = "disableUnusedInterfaces"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
{% for if_name,if_param in interface.items() %}
  {% if if_param['description'] == "" %}
interfaces {
    {{if_param['intfName']}} {
        disable;
   }
}
  {% endif %}
{% endfor %}
EOT

},
]

}