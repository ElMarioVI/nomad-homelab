resource "nomad_dynamic_host_volume" "backup" {
  for_each  = toset(["disk1", "disk2", "disk3", "disk4", "disk5"])
  name      = each.key
  plugin_id = "custom-mkdir"
  node_id   = local.servers["freya"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/${each.key}/backup"
    uid  = "1000"
    gid  = "1000"
  }
}

#resource "nomad_job" "smb-backups" {
#  jobspec = local.jobspec_for["apps/smb-backups"]
#
#  depends_on = [
#    nomad_dynamic_host_volume.backup
#  ]
#}
