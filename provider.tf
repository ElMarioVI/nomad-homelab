terraform {
  required_providers {
    nomad = {
      source = "hashicorp/nomad"
    }
    unifi = {
      source  = "ubiquiti-community/unifi"
    }
  }
}

provider "nomad" {
  address = var.nomad_provider.address
  #secret_id = var.nomad_provider.secret_id
  #ca_pem = var.nomad_provider.ca_pem
}

provider "unifi" {
  api_url        = var.unifi_provider.api_url
  api_key        = var.unifi_provider.api_key
  allow_insecure = true
}
