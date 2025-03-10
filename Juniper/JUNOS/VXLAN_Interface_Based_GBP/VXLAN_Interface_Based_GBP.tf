resource "apstra_configlet" "GBP_Egress_Configlet" {
name = "GBP-Egress-Configlet"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
chassis {                       
    forwarding-options {
        vxlan-gbp-profile;
    }
}

{% set data = namespace(src_tag_list=[]) %}

firewall {
    family any {
       filter MSEG {
{% for all_filters in gbp_info %}
    {% for src_tag, src_tag_filters in all_filters.iteritems() %}
        {% if src_tag not in data.src_tag_list %}
            {% set data.src_tag_list = data.src_tag_list + [src_tag] %}
        {% endif %}
        {% for dst_tag_info in src_tag_filters %}
            {% for dst_tag, action in dst_tag_info.items() %}
        term From{{src_tag}}-To{{dst_tag}} {
            from {
                gbp-src-tag {{src_tag}};
                gbp-dst-tag {{dst_tag}};
            }
            then {
                {{action}};
                count {{src_tag}}-To{{dst_tag}};
                }
            }
            {% endfor %}
        {% endfor %}
    {% endfor %}
{% endfor %}
        }
    }
}

{% set unique_src_tag_list= data.src_tag_list %}



firewall {
    family any {
        filter GBP-TAG {
        micro-segmentation;
{% for src_tag in unique_src_tag_list %}
    {% for if_name,if_param in interface.items() %}
        {% for tags in if_param['tags'] %}
            {% if tags == "gbp_"+src_tag %}
                {% if "ae" not in if_param['intfName'] and "ae" not in if_param['part_of'] %}
        term TAG{{src_tag}}-{{if_param['intfName']}} {
            from {
                interface {{if_param['intfName']}}.0;
            }
            then gbp-tag {{src_tag}};
        }
                {% elif "ae" in if_param['part_of']%}
        term TAG{{src_tag}}-{{if_param['part_of']}} {
            from {
                interface {{if_param['part_of']}}.0;
            }
            then gbp-tag {{src_tag}};
        }
                {% endif %}
            {% endif %}
        {% endfor %}
    {% endfor %}
{% endfor %}
        }
    }
}
EOT

},
]

}