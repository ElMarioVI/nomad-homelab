resource "nomad_dynamic_host_volume" "searxng-data" {
  name      = "searxng-data"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/searxng-data"
    uid  = "977"
    gid  = "977"
  }
}

resource "nomad_job" "searxng" {
  jobspec = local.jobspec_for["apps/searxng"]
}
