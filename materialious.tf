resource "nomad_dynamic_host_volume" "materialious-data" {
  name      = "materialious-data"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/materialious-data"
    uid  = "1000"
    gid  = "1000"
  }
}

resource "nomad_job" "materialious" {
  jobspec = local.jobspec_for["apps/materialious"]
}
