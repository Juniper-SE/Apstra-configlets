resource "apstra_configlet" "isis_vxlan_config" {
name = "isis_vxlan_config"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
{% for key, value in vlan.iteritems() %}
    {% if value["vxlan_id"] == 300000: %}
set interfaces irb unit {{ value["id"] }} family iso
set interfaces lo0 unit 0 family iso address 49.0001.1720.2700.0003.00
set protocols isis interface irb.{{ value["id"] }}
set protocols isis interface lo0.0 level 1 disable
set protocols isis interface lo0.0 level 2 passive
set protocols isis level 1 disable
set protocols isis level 2 wide-metrics-only
set protocols isis enable
	{% endif %}
{% endfor %}
EOT

},
]

}