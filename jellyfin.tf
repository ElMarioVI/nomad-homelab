resource "nomad_dynamic_host_volume" "jellyfin-cache" {
  name      = "jellyfin-cache"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/jellyfin-cache"
  }
}

resource "nomad_dynamic_host_volume" "jellyfin-data" {
  name = "jellyfin-data"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/jellyfin-data"
  }
}

resource "nomad_dynamic_host_volume" "anime" {
  name      = "anime"
  plugin_id = "custom-smb"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-reader-only"
    attachment_mode = "file-system"
  }
  parameters = {
    smb_server = local.smb_media_ro["address"]
    smb_user = local.smb_media_ro["user"]
    smb_pass = local.smb_media_ro["pass"]
  }
}

resource "nomad_dynamic_host_volume" "peliculas-a" {
  name      = "peliculas_a"
  plugin_id = "custom-smb"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-reader-only"
    attachment_mode = "file-system"
  }
  parameters = {
    smb_server = local.smb_media_ro["address"]
    smb_user = local.smb_media_ro["user"]
    smb_pass = local.smb_media_ro["pass"]
  }
}

resource "nomad_dynamic_host_volume" "peliculas-b" {
  name      = "peliculas_b"
  plugin_id = "custom-smb"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-reader-only"
    attachment_mode = "file-system"
  }
  parameters = {
    smb_server = local.smb_media_ro["address"]
    smb_user = local.smb_media_ro["user"]
    smb_pass = local.smb_media_ro["pass"]
  }
}

resource "nomad_dynamic_host_volume" "series" {
  name      = "series"
  plugin_id = "custom-smb"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-reader-only"
    attachment_mode = "file-system"
  }
  parameters = {
    smb_server = local.smb_media_ro["address"]
    smb_user = local.smb_media_ro["user"]
    smb_pass = local.smb_media_ro["pass"]
  }
}

resource "nomad_dynamic_host_volume" "musica" {
  name      = "musica"
  plugin_id = "custom-smb"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-reader-only"
    attachment_mode = "file-system"
  }
  parameters = {
    smb_server = local.smb_media_ro["address"]
    smb_user = local.smb_media_ro["user"]
    smb_pass = local.smb_media_ro["pass"]
  }
}

resource "nomad_dynamic_host_volume" "libros" {
  name      = "libros"
  plugin_id = "custom-smb"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-reader-only"
    attachment_mode = "file-system"
  }
  parameters = {
    smb_server = local.smb_media_ro["address"]
    smb_user = local.smb_media_ro["user"]
    smb_pass = local.smb_media_ro["pass"]
  }
}

resource "nomad_job" "jellyfin" {
  jobspec = local.jobspec_for["apps/jellyfin"]

  depends_on = [
    nomad_dynamic_host_volume.jellyfin-cache,
    nomad_dynamic_host_volume.jellyfin-data,
    nomad_dynamic_host_volume.anime,
    nomad_dynamic_host_volume.peliculas-a,
    nomad_dynamic_host_volume.peliculas-b,
    nomad_dynamic_host_volume.series,
    nomad_dynamic_host_volume.musica,
    nomad_dynamic_host_volume.libros
  ]
}
