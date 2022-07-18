This configlet sets duplicate MAC detection timers for evpn
The [junos documentation](https://www.juniper.net/documentation/us/en/software/junos/evpn-vxlan/topics/task/configuring-mac-mobility-settings.html) has serveral options we focus just on one

Here is the stanza for the setting:
```
protocols evpn {
	duplicate-mac-detection {
		auto-recovery-time 22;
	}
}
