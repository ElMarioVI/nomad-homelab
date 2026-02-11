data "nomad_variable" "servers" {
  path = "servers"
}

data "nomad_variable" "smb_media_ro" {
  path = "smb/media_ro"
}

data "nomad_datacenters" "dc" {}
