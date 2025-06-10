resource "apstra_configlet" "Unused_Interfaces_Power_Saving" {
name = "Unused Interfaces Power Saving"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
# Initialise an empty list to store unused interfaces
{% set unused_intfs = [] %}

# Iterate through all interfaces
{% for iface_data in interface.values() %}
    # Skip interfaces that are already in portSetting (these are active interfaces)
    {% if iface_data['intfName'] in portSetting %}
        {% continue %}
    {% endif %}

    # Get port settings for the current interface
    {% set iface_port_settings = iface_data.get('port_setting') or {} %}

    # Check if the interface is a child of a breakout interface
    {% set parent = iface_port_settings.get('interface', {}).get('parent_breakout_interface', [])[:1] %}

    {% if parent %}
        # If it's a child interface and its parent is not in portSetting, add the parent to unused_intfs
        {% if portSetting is defined and parent[0] not in portSetting %}
            {% do unused_intfs.append(parent[0]) %}
        {% endif %}
    {% elif iface_data['is_standalone'] and iface_data['role'] == 'unused' and portSetting is defined and iface_data['intfName'] not in portSetting %}
        # If it's a standalone interface, marked as unused, and not in portSetting, add it to unused_intfs
		{% do unused_intfs.append(iface_data['intfName']) %}
    {% endif %}
{% endfor %}

# Generate the configuration for unused interfaces
{% for intf_name in function.sorted_alphabetical(unused_intfs|unique) %}
    {% if loop.first %}
# Start the interfaces configuration block
interfaces {
    {% endif %}
    # Set each unused interface to 'unused' status
    {{intf_name}} {
        unused;
    }
    {% if loop.last %}
# Close the interfaces configuration block
}
    {% endif %}
{% endfor %}
EOT

},
]

}