resource "nomad_dynamic_host_volume" "matrix-synapse" {
  name      = "matrix-synapse"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/matrix-synapse"
    uid  = "991"
    gid  = "991"
  }
}

resource "nomad_dynamic_host_volume" "matrix-postgres" {
  name      = "matrix-postgres"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/matrix-postgres"
  }
}

resource "nomad_dynamic_host_volume" "matrix-mas" {
  name      = "matrix-mas"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/matrix-mas"
    uid = "1000"
    gid = "1000"
  }
}

resource "nomad_dynamic_host_volume" "matrix-mas-postgres" {
  name      = "matrix-mas-postgres"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/matrix-mas-postgres"
  }
}

resource "nomad_job" "matrix" {
  jobspec = local.jobspec_for["apps/matrix"]

  depends_on = [
    nomad_dynamic_host_volume.matrix-synapse,
    nomad_dynamic_host_volume.matrix-postgres,
    nomad_dynamic_host_volume.matrix-mas,
    nomad_dynamic_host_volume.matrix-mas-postgres
  ]
}
