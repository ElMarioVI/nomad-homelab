job "enshrouded" {
  type        = "service"
  datacenters = __DATACENTER__

  group "server" {
    update {
      healthy_deadline  = "30m"
      progress_deadline = "35m"
    }

    volume "game" {
      type   = "host"
      source = "enshrouded"
    }

    service {
      name         = "enshrouded"
      port         = 15637
      provider     = "nomad"
      address_mode = "alloc"
      check {
        address_mode = "alloc"
        type         = "tcp"
        port         = 15637
        interval     = "30s"
        timeout      = "5s"
      }
    }

    network {
      mode = "cni/containers"
      cni {
        args = {
          NOMAD_JOB_HOSTNAME = "enshrouded-gameservers"
          MAC                = "__MAC_ENSHROUD__"
        }
      }
    }

    task "network-rules" {
      driver = "podman"
      lifecycle {
        hook    = "prestart"
        sidecar = true
      }
      config {
        image      = "ghcr.io/elmariovi/net-nomad:latest"
        cap_add    = ["NET_ADMIN"]
      }
      template {
        data        = var.firewall_config
        destination = "local/firewall.env"
        env         = true
      }
      resources {
        cpu        = 10
        memory     = 10
        memory_max = 16
      }
    }

    task "app" {
      driver = "podman"
      volume_mount {
        volume      = "game"
        destination = "/game"
      }
      config {
        image              = "ghcr.io/elmariovi/proton:latest"
        image_pull_timeout = "30m"
        entrypoint = ["/local/entrypoint.sh"]
        volumes = [
          "local/config.json:/game/enshrouded_server.json"
        ]
      }
      template {
        data        = var.enshrouded_entrypoint
        destination = "local/entrypoint.sh"
        perms       = "755"
      }
      template {
        data        = var.enshrouded_config
        destination = "local/config.json"
      }
      resources {
        cpu    = 8000
        memory = 8000
      }
    }
  }
}
