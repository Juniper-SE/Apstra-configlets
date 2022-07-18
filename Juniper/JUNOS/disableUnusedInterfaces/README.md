This configlet is a [dynamic jinja-based template](https://supportportal.juniper.net/s/article/Juniper-Apstra-Jinja-Configlets-using-dynamic-data-from-deviceModel?language=en_US) whch disables unused interfaces by searching for any interfaces that do not have a description and disabling them.

note: deviceModel is a hidden and undocumented feature.

Here is the jinja code for the configlet, which searches for a blank description field and if it is then it sets the interface to disable.

```
{% for if_name,if_param in interface.items() %}
  {% if if_param['description'] == "" %}
interfaces {
    {{if_param['intfName']}} {
        disable;
   }
}
  {% endif %}
{% endfor %}
