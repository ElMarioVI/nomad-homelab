resource "nomad_dynamic_host_volume" "vaultwarden" {
  name      = "vaultwarden"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/vaultwarden"
  }
}

resource "nomad_job" "vaultwarden" {
  jobspec = local.jobspec_for["apps/vaultwarden"]

  depends_on = [
    nomad_dynamic_host_volume.vaultwarden
  ]
}
