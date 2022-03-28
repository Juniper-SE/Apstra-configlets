# Workflow

To deploy tcp-ao with junos devices follow the following workflow.
1. create a key or several keys.
    - the keys have a start date associated with them, which allows for key rollover.
    ```junos
    set security authentication-key-chains key-chain JPW-Chain key 1 secret juniperApstraSecret
    set security authentication-key-chains key-chain JPW-Chain key 1 start-time "2022-3-28.12:00:00 +0000"
    set security authentication-key-chains key-chain JPW-Chain key 1 algorithm ao
    set security authentication-key-chains key-chain JPW-Chain key 1 ao-attribute send-id 1
    set security authentication-key-chains key-chain JPW-Chain key 1 ao-attribute recv-id 1
    set security authentication-key-chains key-chain JPW-Chain key 1 ao-attribute tcp-ao-option enabled
    set security authentication-key-chains key-chain JPW-Chain key 1 ao-attribute cryptographic-algorithm aes-128-cmac-96

2. assign the key to the protocol bgp heirarchy / stanza
   - You can either deploy the key to the following levels 
      - bgp stanza at the top level
      - bgp group level (all neighbors in that group)
      ```
     set protocols bgp group l3clos-l-evpn authentication-algorithm ao
     set protocols bgp group l3clos-l-evpn authentication-key-chain JPW-Chain 
      - bgp neighbor level (the unique neighbors you select)
3. you may want to assign the keys to the underlay, overlay or both layers of the blueprint.

    

