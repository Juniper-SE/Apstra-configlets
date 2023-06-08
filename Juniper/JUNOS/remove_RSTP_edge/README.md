This example configlet is a [dynamic [jinja-based template](https://supportportal.juniper.net/s/article/Juniper-Apstra-Jinja-Configlets-using-dynamic-data-from-deviceModel?language=en_US) that removes the RSTP edge configuration from a given interface. 

The configlet will loop through every interface, and every tag assigned to the interface. If the interface contains a tag called "no-rstp-edge" then the corresponding delete statement will be created. You can change the tag value to anything that makes sense for your environment.

Here is the jinja code for the configlet.

```
{% for if_name,if_param in interface.items() %}
  {% for tags in if_param['tags'] %}
   {% if tags == "no-rstp-edge" %}
delete protocols rstp interface {{ if_param['intfName'] }} edge
    {% endif %}
  {% endfor %}
{% endfor %}