resource "nomad_dynamic_host_volume" "qbittorrent-downloads" {
  name      = "qbittorrent-downloads"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/qbittorrent-downloads"
    uid  = "1000"
    gid  = "1000"
  }
}

resource "nomad_dynamic_host_volume" "qbittorrent-config" {
  name      = "qbittorrent-config"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/qbittorrent-config"
    uid  = "1000"
    gid  = "1000"
  }
}

resource "nomad_job" "qbittorrent" {
  jobspec = local.jobspec_for["apps/qbittorrent"]

  depends_on = [
    nomad_dynamic_host_volume.qbittorrent-downloads,
    nomad_dynamic_host_volume.qbittorrent-config
  ]
}

resource "nomad_job" "smb-downloads" {
  jobspec = local.jobspec_for["apps/smb-downloads"]

  depends_on = [
    nomad_dynamic_host_volume.qbittorrent-downloads
  ]
}
