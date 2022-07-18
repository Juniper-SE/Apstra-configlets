# Configlets & Property Sets

Apstra automates the creation and management of Leaf/Spine IP Fabrics. Apstra derives a validated configuration as part of the Intent based abstraction model which addresses the large part of the VXLAN EVPN reference design. For any configuration that lives outside of the Apstra reference design, a feature known as a ‘Configlet’ can be used. A configlet allows the administrator to create configuration templates and have them automatically deployed to devices based on the Intent. The configlet management system is designed to support multiple vendor and syntax types.

The Configlet can be married with the Proprty set
More information can be found here: https://www.juniper.net/documentation/us/en/software/apstra/apstra4.0/configlets.html?highlight=configlet#configlets

The directory structure for this repo is straightforward, each configlet is listed under the device brand ie ```Juniper/JUNOS``` and under that directory there is a list of the configlets.  Once you get into the configlet of interest there will be a ```README``` file with some information on the configlet.

# POSTMAN
There is a postman collection included in the base directory that will provide API access to the configlets that mirrors the directories and configlets, so you will easily be able to push any given configlet to the chosen Apstra API via REST.
