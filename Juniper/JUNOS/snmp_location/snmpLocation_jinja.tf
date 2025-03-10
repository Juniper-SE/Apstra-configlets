resource "apstra_configlet" "junos_snmp_location_jinja" {
name = "junos-snmp-location-jinja"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
{% set snmp_location = {} %}
{% set test = snmp_location.update({'Leaf-30': 'DC1-Rack30'}) %}
{% set test = snmp_location.update({'Leaf-31': 'DC1-Rack31'}) %}
{% set test = snmp_location.update({'Leaf-32': 'DC1-Rack32'}) %}
{% set test = snmp_location.update({'Leaf-33': 'DC1-Rack33'}) %}
{% set test = snmp_location.update({'Leaf-34': 'DC2-Rack34'}) %}
{% set test = snmp_location.update({'Leaf-35': 'DC2-Rack35'}) %}
 
{% if snmp_location[hostname] is defined %}
snmp {
    location "{{snmp_location[hostname]}}";
}
{% endif %}
EOT

},
]

}