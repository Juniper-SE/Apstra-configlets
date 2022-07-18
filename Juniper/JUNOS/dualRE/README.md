This configlet is to enable the proper function of a dual-re (routing engine) junos system.
This configlet will perform the following tasks :

- [syncrhronise the commits to both REs](https://www.juniper.net/documentation/us/en/software/junos/cli/topics/topic-map/synchronising-routing-engines.html)

- [set a group for both REs management interfaces](https://www.juniper.net/documentation/us/en/software/junos/junos-overview/topics/task/routing-engine-dual-initial-configuration.html)
- [set the chassis redundancy to RE0 as master and RE1 as backup](https://www.juniper.net/documentation/us/en/software/junos/high-availability/topics/task/routing-engine-redundancy-configuring.html)
- [set the chassis to fail over on loss of keepalives](https://www.juniper.net/documentation/us/en/software/junos/high-availability/topics/task/routing-engine-redundancy-configuring.html#section-re-redundancy-on-loss-of-keepalives)
- [set the chassis to fail over on a disk failure](https://www.juniper.net/documentation/us/en/software/junos/high-availability/topics/task/routing-engine-redundancy-configuring.html#section-re-redundancy-on-disk-failure)
- [set the chassis to graceful-switchover](https://www.juniper.net/documentation/us/en/software/junos/high-availability/topics/task/gres-configuring.html)

Here are the set commands for the configlet:
```
set system commit synchronize
set groups re0 interfaces em1 unit 0 family inetaddress {{re0_ipv4inet}}
set groups re0 interfaces em1 unit 0 family inetaddress {{re0_ipv4inet_master}} master-only
set groups re1 interfaces em1 unit 0 family inetaddress {{re1_ipv4inet}}
set groups re1 interfaces em1 unit 0 family inetaddress {{re1_ipv4inet_master}} master-only
set chassis redundancy routing-engine 0 master
set chassis redundancy routing-engine 1 backup
set chassis redundancy failover on-loss-of-keepalives
set chassis redundancy failover on-disk-failure
set chassis redundancy graceful-switchover 
```

Here is an example of the variables and initial values for the propertyset:

 - re1_ipv4inet_master: 192.168.0.50/24
 - re0_ipv4inet:  192.168.0.51/24
 - re1_ipv4inet: 192.168.0.52/24
 - re0_ipv4inet_master: 192.168.0.50/24
