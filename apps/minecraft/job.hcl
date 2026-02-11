job "minecraft" {
  type        = "service"
  datacenters = __DATACENTER__

  group "server" {
    update {
      healthy_deadline  = "30m"
      progress_deadline = "35m"
    }

    volume "data" {
      type   = "host"
      source = "minecraft"
    }

    service {
      name         = "minecraft"
      port         = 25565
      provider     = "nomad"
      address_mode = "alloc"
      check {
        address_mode = "alloc"
        type         = "tcp"
        port         = 25565
        interval     = "30s"
        timeout      = "5s"
      }
    }

    network {
      mode = "cni/containers"
      cni {
        args = {
          NOMAD_JOB_HOSTNAME = "minecraft-gameservers"
          MAC                = "__MAC_MINECRAFT__"
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
        volume      = "data"
        destination = "/data"
      }

      config {
        image              = "docker.io/itzg/minecraft-server:java21"
        image_pull_timeout = "30m"
      }

      template {
        data        = var.minecraft_env
        destination = "local/minecraft.env"
        env         = true
      }

      resources {
        cpu    = 4000
        memory = 12288
      }
    }
  }
}
