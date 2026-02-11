
resource "nomad_dynamic_host_volume" "immich-data" {
  name      = "immich-data"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/immich-data"
    uid  = "1000"
    gid  = "1000"
  }
}

resource "nomad_dynamic_host_volume" "immich-cache" {
  name      = "immich-cache"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/immich-cache"
    uid  = "1000"
    gid  = "1000"
  }
}

resource "nomad_dynamic_host_volume" "immich-database" {
  name      = "immich-database"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/immich-database"
    uid  = "1000"
    gid  = "1000"
  }
}

resource "nomad_job" "immich" {
  jobspec = local.jobspec_for["apps/immich"]

  depends_on = [
    nomad_dynamic_host_volume.immich-data,
    nomad_dynamic_host_volume.immich-cache,
    nomad_dynamic_host_volume.immich-database
  ]
}
