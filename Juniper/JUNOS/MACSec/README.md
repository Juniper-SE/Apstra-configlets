Revised:  
Owners: Andy Ford

Status: Incomplete draft

# 

[<u>Background</u>](#background)

[<u>Problem Statement</u>](#problem-statement)

[<u>How to re-create this test</u>](#how-to-re-create-this-test)

> [<u>Adding an external router</u>](#adding-an-external-router)
>
> [<u>View from DC1</u>](#view-from-dc1)
>
> [<u>View from DC2</u>](#view-from-dc2)
>
> [<u>P2P link IP addressing</u>](#p2p-link-ip-addressing)
>
> [<u>View from DC1</u>](#view-from-dc1-1)
>
> [<u>View from DC2</u>](#view-from-dc2-1)

[<u>Configuring MACsec Using CAK</u>](#configuring-macsec-using-cak)

> [<u>To configure MACsec using static CAK security
> mode</u>](#to-configure-macsec-using-static-cak-security-mode)
>
> [<u>Create a connectivity
> association</u>](#create-a-connectivity-association)
>
> [<u>How to view MACSec working</u>](#how-to-view-macsec-working)
>
> [<u>How the configlets looks in
> AIS</u>](#how-the-configlets-looks-in-ais)

# 

#  

# Background

<span class="mark">Media Access Control Security (MACsec) is an
industry-standard security technology that provides secure communication
for almost all types of traffic on Ethernet links. MACsec provides
point-to-point security on Ethernet links between directly-connected
nodes and is capable of identifying and preventing most security
threats, including denial of service, intrusion, man-in-the-middle,
masquerading, passive wiretapping, and playback attacks. MACsec is
standardized in IEEE 802.1AE.</span>

<span class="mark">You can configure MACsec to secure point-to-point
Ethernet links connecting switches, or on Ethernet links connecting a
switch to a host device such as a PC, phone, or server. Each
point-to-point Ethernet link that you want to secure using MACsec must
be configured independently. Two approaches to implementing
MACSec</span>

1.  <span class="mark">Static Secure Association Key (SAK) security
    mode</span>

2.  <span class="mark">Static Connectivity Association Key (CAK)</span>

<span class="mark">CAK is the preferred method for switches, as
described below.</span>

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p><a
href="https://www.juniper.net/documentation/en_US/junos/topics/task/configuration/macsec.html"><u>Juniper
Best Practice Statement</u></a></p>
<p>We recommend enabling MACsec using static CAK security mode on
switch-to-switch links. Static CAK security mode ensures security by
frequently refreshing to a new random secure association key (SAK) and
by only sharing the SAK between the two devices on the MACsec-secured
point-to-point link. Additionally, some optional MACsec features—replay
protection, SCI tagging, and the ability to exclude traffic from
MACsec—are only available in static CAK security mode.</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p><strong><mark><u>Note:</u></mark></strong></p>
<p><mark>A feature license is required to configure MACsec on an EX
Series or a QFX Series switch, with the exception of the
QFX10000-6C-DWDM and QFX10000-30C-M line cards. If the MACsec licence is
not installed, MACsec functionality cannot be activated.</mark></p>
<p><mark>The MACsec feature license is an independent feature license
and not part of an enhanced or advanced feature license aka EFL /
AFL</mark></p></td>
</tr>
</tbody>
</table>

# Problem Statement

P2P DCI links at Juniper are often secured with MACSec. With AOS
v3.3.0.2, MACSec isn’t supported as part of the Intent model. This
document describes how to deploy MACSec with a configlet.

# How to re-create this test

The config used in the configlet was built by using set commands on two
QFX5120-48YM switches in a lab environment. In this lab, port et-0/0/48
on both switches, were connected together, to simulate the DCI
connection.

Two Blueprints were created which consisted of an undeployed spine and
the deployed QFX5120-48YM border leaf.

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr class="odd">
<td>AIS topology - view from DC2</td>
<td>External Routers</td>
</tr>
<tr class="even">
<td><img src="./attachments/$myfilename/media/image1.png"
style="width:3.10417in;height:2.91667in" /></td>
<td><ul>
<li><p><mark>MACsec-DC1-BL</mark></p>
<ul>
<li><p><mark>192.168.0.9</mark></p></li>
<li><p><mark>64521</mark></p></li>
</ul></li>
<li><p><mark>MACsec-DC2-BL</mark></p>
<ul>
<li><p><mark>192.168.0.13</mark></p></li>
<li><p><mark>64523</mark></p></li>
</ul></li>
</ul></td>
</tr>
</tbody>
</table>

## Adding an external router

In each BP, an external router was created on et-0/0/48 and the opposite
BL added as an external router

### View from DC1

<img src="./attachments/$myfilename/media/image2.png"
style="width:6.5in;height:0.81944in" />

### View from DC2

<img src="./attachments/$myfilename/media/image3.png"
style="width:6.5in;height:1in" />

## P2P link IP addressing

The interface IP addresses were manually added as 1.1.1.0/31 on both
switches as shown below

### View from DC1

<img src="./attachments/$myfilename/media/image4.png"
style="width:5.77604in;height:1.28665in" />

### View from DC2

<img src="./attachments/$myfilename/media/image5.png"
style="width:5.74479in;height:1.25207in" />

# Configuring MACsec Using CAK 

When you enable MACsec using static CAK security mode, a pre-shared key
is exchanged between the switches on each end of the point-to-point
Ethernet link. The pre-shared key includes a connectivity association
name (CKN) and a connectivity association key (CAK). The CKN and CAK are
configured by the user in the connectivity association and must match on
both ends of the link to initially enable MACsec.

Only when the keys are exchanged and verified will MACSec be enabled on
the link. <span class="mark">The randomized security key enables and
maintains MACsec on the point-to-point link. The key server will
continue to periodically create and share a randomly-created security
key over the point-to-point link for as long as MACsec is
enabled.</span>

<span class="mark">You enable MACsec using static CAK security mode by
configuring a connectivity association on both ends of the link. All
configuration is done within the connectivity association but outside of
the secure channel. Two secure channels—one for inbound traffic and one
for outbound traffic—are automatically created when using static CAK
security mode. The automatically-created secure channels do not have any
user-configurable parameters that cannot already be configured in the
connectivity association.</span>

## To configure MACsec using static CAK security mode

### Create a connectivity association

**<span class="mark">set security macsec connectivity-association
DCI-link cipher-suite gcm-aes-xpn-128</span>**

**<span class="mark">set security macsec connectivity-association
DCI-link security-mode static-cak</span>**

**<span class="mark">set security macsec connectivity-association
DCI-link include-sci</span>**

**<span class="mark">set security macsec connectivity-association
DCI-link pre-shared-key ckn
1122334455667788991102132415361748195011621374158617981900F1F2F3</span>**

**<span class="mark">set security macsec connectivity-association
DCI-link pre-shared-key cak "12345678910121314151617181910FFF"</span>**

**<span class="mark">set security macsec interfaces et-0/0/48
connectivity-association DCI-link</span>**

This results in the following configuration which was copy/pasted into a
Configlet

*<span class="mark">security {</span>*

*<span class="mark">macsec {</span>*

*<span class="mark">connectivity-association DCI-link {</span>*

*<span class="mark">cipher-suite gcm-aes-xpn-128;</span>*

*<span class="mark">security-mode static-cak;</span>*

*<span class="mark">include-sci;</span>*

*<span class="mark">pre-shared-key {</span>*

*<span class="mark">ckn
1122334455667788991102132415361748195011621374158617981900F1F2F3;</span>*

*<span class="mark">cak
"$9$4baDiqmfzn/.mIESrvMDiHkTzp0BIhS/9lKW87NjHkPz369AOIEn6KM8LN-mf5Q69BIEcreRE-Vw2aJFn6/p0hcr8L7s2";</span>*

*<span class="mark">}</span>*

*<span class="mark">}</span>*

*<span class="mark">interfaces {</span>*

<span class="mark"> *et-0/0/48 {*</span>

*<span class="mark">connectivity-association DCI-link;</span>*

*<span class="mark">}</span>*

*<span class="mark">}</span>*

*<span class="mark">}</span>*

*<span class="mark">}</span>*

### How to view MACSec working

<span class="mark">tzieger@DC2-BL1# **run show security macsec
connections **</span>

<span class="mark">Interface name: et-0/0/48</span>

<span class="mark">CA name: DCI-link</span>

<span class="mark">Cipher suite: GCM-AES-XPN-128 Encryption: on</span>

<span class="mark">Key server offset: 0 Include SCI: yes</span>

<span class="mark">Replay protect: off Replay window: 0</span>

<span class="mark">Outbound secure channels</span>

<span class="mark">SC Id: 40:8F:9D:49:6E:B5/1</span>

<span class="mark">Outgoing packet number: 561</span>

<span class="mark">Secure associations</span>

<span class="mark">AN: 0 Status: inuse Create time: 01:24:05</span>

<span class="mark">Inbound secure channels</span>

<span class="mark">SC Id: 40:8F:9D:4A:04:B5/1</span>

<span class="mark">Secure associations</span>

<span class="mark">AN: 0 Status: inuse Create time: 01:24:05</span>

### How the configlets looks in AIS

<img src="./attachments/$myfilename/media/image6.png"
style="width:6.00521in;height:5.34749in" />
