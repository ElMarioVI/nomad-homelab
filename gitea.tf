resource "nomad_dynamic_host_volume" "gitea-data" {
  name      = "gitea-data"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/gitea/data"
    uid  = "1000"
    gid  = "1000"
  }
}

resource "nomad_dynamic_host_volume" "gitea-database" {
  name      = "gitea-database"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/gitea/database"
  }
}

resource "nomad_job" "gitea" {
  jobspec = local.jobspec_for["apps/gitea"]

  depends_on = [
    nomad_dynamic_host_volume.gitea-data,
    nomad_dynamic_host_volume.gitea-database,
  ]
}
