resource "nomad_dynamic_host_volume" "invidious-database" {
  name      = "invidious-database"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/invidious-database"
    uid  = "70"
    gid  = "70"
  }
}

resource "nomad_job" "invidious" {
  jobspec = local.jobspec_for["apps/invidious"]
}
