This configlet is a [dynamic jinja-based template](https://supportportal.juniper.net/s/article/Juniper-Apstra-Jinja-Configlets-using-dynamic-data-from-deviceModel?language=en_US) whch sets the SNMP Location based on a lookup of the device name in the device model.  

note: deviceModel is a hidden and undocumented feature.

Here is the jinja code that does the work understand the matching information is an example and should be tuned to your environment.

```
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