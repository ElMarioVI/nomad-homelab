resource "nomad_dynamic_host_volume" "enshrouded" {
  name      = "enshrouded"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/enshrouded"
  }
}

#resource "nomad_job" "enshrouded" {
#  jobspec = local.jobspec_for["apps/enshrouded"]
#
#  depends_on = [
#    nomad_dynamic_host_volume.enshrouded
#  ]
#}

# ==================== MINECRAFT ====================
resource "nomad_dynamic_host_volume" "minecraft" {
  name      = "minecraft"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/minecraft"
  }
}

#resource "nomad_job" "minecraft" {
#  jobspec = local.jobspec_for["apps/minecraft"]
#
#  depends_on = [
#    nomad_dynamic_host_volume.minecraft
#  ]
#}

# ==================== HYTALE ====================
resource "nomad_dynamic_host_volume" "hytale" {
  name      = "hytale"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/hytale"
  }
}

#resource "nomad_job" "hytale" {
#  jobspec = local.jobspec_for["apps/hytale"]
#
#  depends_on = [
#    nomad_dynamic_host_volume.hytale
#  ]
#}
