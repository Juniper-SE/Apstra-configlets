# Configlets & Property Sets

Apstra automates the creation and management of Leaf/Spine IP Fabrics. Apstra derives a validated configuration as part of the Intent based abstraction model which addresses the large part of the VXLAN EVPN reference design. For any configuration that lives outside of the Apstra reference design, a feature known as a ‘Configlet’ can be used. A configlet allows the administrator to create configuration templates and have them automatically deployed to devices based on the Intent. The configlet management system is designed to support multiple vendor and syntax types.

The Configlet can be married with the Property set
More information can be found here: https://www.juniper.net/documentation/us/en/software/apstra/apstra4.0/configlets.html?highlight=configlet#configlets

The directory structure for this repo is straightforward, each configlet is listed under the device brand ie ```Juniper/JUNOS``` and under that directory there is a list of the configlets.  Once you get into the configlet of interest there will be a ```README``` file with some information on the configlet.

# How to Use

https://github.com/user-attachments/assets/85813feb-f3ba-4613-841a-d608be185559

# POSTMAN
There is a postman collection included in the base directory that will provide API access to the configlets that mirrors the directories and configlets, so you will easily be able to push any given configlet to the chosen Apstra API via REST.

# Terraform
The terraform provider for Apstra can be used to deploy the configlets.
The ./tf directory has the provider.tf and the environment variables needed.
Fill out apstra_env.sh
copy the terraform file (.tf) from the appropriate directory
Then follow these steps. In this example, the QFX10K_HashingFix.tf is being applied.
If multiple configlets are required, all the tf files can be copied in and deployed in one shot. 
```commandline
% cd tf
% source apstra_env.sh
% cp ../Juniper/JUNOS/10K_hashing_fix/QFX10K-HashingFix-Configlet.tf ./
% terraform init
% terraform apply% terraform apply                  

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # apstra_configlet.QFX10K_HashingFix will be created
  + resource "apstra_configlet" "QFX10K_HashingFix" {
      + generators = [
          + {
              + config_style  = "junos"
              + section       = "top_level_set_delete"
              + template_text = <<-EOT
                    set forwarding-options hash-key family inet layer-4
                EOT
            },
        ]
      + id         = (known after apply)
      + name       = "QFX10K-HashingFix"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

apstra_configlet.QFX10K_HashingFix: Creating...
apstra_configlet.QFX10K_HashingFix: Creation complete after 1s [id=b9b95a4f-6871-4e81-8ab3-a66a7ec91953]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```