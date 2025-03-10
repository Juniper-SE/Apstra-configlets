terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
    }
  }
}

provider "apstra" {
  #experimental            = true # Needed for any version > 4.2.1
  #tls_validation_disabled = true
  blueprint_mutex_enabled = false
}

