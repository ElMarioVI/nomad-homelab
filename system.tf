resource "nomad_dynamic_host_volume" "letsencrypt" {
  name      = "letsencrypt"
  plugin_id = "custom-mkdir"
  node_id   = local.servers["thor"]
  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
  capability {
    access_mode     = "single-node-reader-only"
    attachment_mode = "file-system"
  }
  parameters = {
    path = "/mnt/local/letsencrypt"
  }
}

resource "nomad_job" "certbot" {
  jobspec = local.jobspec_for["apps/certbot"]

  depends_on = [
    nomad_dynamic_host_volume.letsencrypt
  ]
}

resource "nomad_job" "load-balancer" {
  jobspec = local.jobspec_for["apps/load-balancer"]

  depends_on = [
    nomad_dynamic_host_volume.letsencrypt
   ]
}
