resource "apstra_configlet" "Remove_RSTP_Edge_Configuration_Per_Port_" {
name = "Remove RSTP Edge Configuration (Per Port)"
generators = [
{
	config_style = "junos" 
	section = "top_level_set_delete" 
	template_text = <<-EOT
{# This configlet looks for the tag 'no-rstp' on an interface and if #} 
{# found deletes the RSTP edge configuration for that port #}
{% for if_name,if_param in interface.items() %}
  {% for tags in if_param['tags'] %}
   {% if tags == "no-rstp-edge" %}
delete protocols rstp interface {{ if_param['intfName'] }} edge
    {% endif %}
  {% endfor %}
{% endfor %}
EOT

},
]

}