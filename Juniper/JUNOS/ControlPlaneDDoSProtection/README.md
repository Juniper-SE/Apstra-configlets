Examples for Configuring Control Plane DDoS Protection on QFX Series Switches can be found [here:](https://www.juniper.net/documentation/us/en/software/junos/security-services/topics/example/ddos-example-qfx-series.html)
The juniper [docs state the default](https://www.juniper.net/documentation/us/en/software/junos/security-services/topics/ref/statement/protocols-edit-ddos-qfx-series.html) for this is 300 and burst of 10 
Here are the set commands needed for the configlet:
``` 
    set system ddos-protection protocols vxlan aggregate bandwidth 1000 
    set system ddos-protection protocols vxlan aggregate burst 400

