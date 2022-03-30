For the juniper QFX10K switches, from the following [juniper.net documentation:](https://www.juniper.net/documentation/us/en/software/junos/sampling-forwarding-monitoring/topics/concept/policy-configuring-per-packet-load-balancing.html)
By default, Junos ignores port data when determining flows. To include port data in the flow determination, include the ```family inet``` statement at the ```[edit forwarding-options hash-key]``` hierarchy level: 
    
    [edit forwarding-options hash-key]
        family inet {
            layer-3;
            layer-4;
        }
In our case we only are looking for layer-4 information, so the correct configlet should look like the following:

```set forwarding-options hash-key family inet layer-4```

Here is a simple screenshot showing how a configlet should look:

In the reference design you would apply this on both spine and leaf QFX switches.

In our testing we have found support in the following platforms:
- QFX10k
- Model: qfx5130-32cd Junos: 21.2R2.17-EVO

It is probably important to try the set command on a switch in your environment before you deploy the configlet on it. if it is not supported you will see something similar to this:
```
    {master:0}[edit]
    aosadmin@spine1# show forwarding-options 
    ##
    ## Warning: configuration block ignored: unsupported platform (qfx5200-32c-32q)
    ##
    hash-key {
        family inet {
            layer-4;
        }
    }

