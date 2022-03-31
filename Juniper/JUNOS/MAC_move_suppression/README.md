Juniper Documentation for reference [MAC move suppression for EVPN](https://www.juniper.net/documentation/us/en/software/junos/evpn-vxlan/topics/ref/statement/duplicate-mac-detection.html)

This Configlet wiil accept 6 MAC moves in 3 minutes (then block them for 5 minutes), here is the stanza:
```
protocols {
    evpn {
        duplicate-mac-detection {
            detection-threshold 6;
            detection-window 180;
            auto-recovery-time 5;
        }
    }
}
 ```
 Here is the information the timers:
```
detection-threshold 6 [times - MAC mobility event ]           Default: 5  Range: 2-20
detection-window 180 [secends]                                Default: 180 secends  / Range: 5-600 sec
auto-recovery-time 5 [minutes]                                Default: not defined / Range: 5-360min
