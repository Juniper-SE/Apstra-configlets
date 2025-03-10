resource "apstra_configlet" "BGP_session_remove" {
name = "BGP_session_remove"
generators = [
{
	config_style = "junos" 
	section = "top_level_set_delete" 
	template_text = <<-EOT
{#
   IMPORTANT: To use this configlet, you must tag the system interfaces
   that are to be decommissioned with the tag 'decomm' in your inventory.
   This configlet will then generate the necessary BGP configuration deletions
   for the tagged interfaces and their corresponding BGP sessions.
#}
 
{# Initialize namespace for storing decommissioned IPs and ASNs #}
{% set ns = namespace(decomm_ips=[], decomm_asn=[]) %}
 
{# Step 1: Collect IP addresses of interfaces tagged with 'decomm' #}
{% for ip_name, ip_data in ip.items() %}
    {% if 'decomm' in ip_data.interface.tags %}
        {# Add the IPv4 address of the tagged interface to our list #}
        {% set ns.decomm_ips = ns.decomm_ips + [ip_data.ipv4_address] %}
    {% endif %}
{% endfor %}
 
{# Step 2: Identify BGP sessions associated with the decommissioned IPs #}
{% for session_name, session_data in bgp_sessions.items() %}
    {% if session_data.source_ip in ns.decomm_ips %}
        {# If the BGP session's source IP matches a decommissioned IP, add its destination ASN to our list #}
        {% set ns.decomm_asn = ns.decomm_asn + [session_data.dest_asn] %}
    {% endif %}
{% endfor %}
 
{# Step 3: Generate BGP configuration deletions for affected sessions #}
{% for session_name, session_data in bgp_sessions.items() %}
    {% if session_data.dest_asn in ns.decomm_asn %}
        {% if session_data.role == 'leaf_evpn' %}
            {# Delete BGP neighbor configuration for EVPN leaf nodes #}
delete protocols bgp group l3clos-l-evpn neighbor {{ session_data.dest_ip }}
        {% elif session_data.role == 'leaf_spine' %}
            {# Delete BGP neighbor configuration for leaf-spine connections #}
delete protocols bgp group l3clos-l neighbor {{ session_data.dest_ip }}
        {% endif %}
    {% endif %}
{% endfor %}
 
{#
   Note: This configlet will generate 'delete' commands for BGP neighbors
   that are connected to interfaces tagged for decommissioning. These commands
   can be applied to remove the BGP peering configurations for the affected devices.
   Always review the generated configuration before applying it to your network.
#}
EOT

},
]

}