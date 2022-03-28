#  tcp-ao junos configlet area.

The junos documenatation for configlets is in the following link:
https://www.juniper.net/documentation/us/en/software/junos/transport-ip/topics/topic-map/tcp-configure-ao-bgp-ldp.html

Here is an [APNIC article](https://blog.apnic.net/2021/07/28/its-time-to-replace-md5-with-tcp-ao/) 

Here is the [RFC on tcp-ao](https://datatracker.ietf.org/doc/html/rfc5925)

The concept is to replace TCP-MD5 auth on BGP sessions with TCP-AO. 

TCP-AO supports multiple keys *up to 64* and time based key rollover.
The advantage is that you could set up multiple keys for a single connection and as a new key start date becomes active the keys will rollover to the next key therefore keeping your keys fresh.

