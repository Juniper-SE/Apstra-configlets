This example configlet is a [dynamic [jinja-based template](https://supportportal.juniper.net/s/article/Juniper-Apstra-Jinja-Configlets-using-dynamic-data-from-deviceModel?language=en_US) that removes the RSTP edge configuration from a given interface. 

The configlet will loop through every interface, and every tag assigned to the interface. If the interface contains a tag called "no-rstp-edge" then the corresponding delete statement will be created. You can change the tag value to anything that makes sense for your environment.

You have two choices when tagging interface level objects - it can be done via tagging the link which will represents the link between both devcie A and device B or by tagging just the one interface. Use `if_param['tags']` if you are using link tags and `if_param['intf_tags']` if using interface tags. This exmaple configlet uses interface tags using `if_param['tags']`.

![CleanShot 2025-04-08 at 10 04 47@2x](https://github.com/user-attachments/assets/3bf29277-b92c-4899-bf5c-739f114f26ff)





Here is the jinja code for the configlet.

```
{% for if_name,if_param in interface.items() %}
  {% for tags in if_param['tags'] %}
   {% if tags == "no-rstp-edge" %}
delete protocols rstp interface {{ if_param['intfName'] }} edge
    {% endif %}
  {% endfor %}
{% endfor %}
