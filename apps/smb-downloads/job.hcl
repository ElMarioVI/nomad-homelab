job "smb-downloads" {
  datacenters = __DATACENTER__
  type        = "service"

  secret "secrets" {
    provider = "nomad"
    path     = "nomad/jobs/smb-downloads"
  }

  group "smb-downloads" {
    volume "qbittorrent" {
      source = "qbittorrent-downloads"
      type   = "host"
    }

    network {
      mode = "cni/containers"
      cni {
        args = {
          NOMAD_JOB_HOSTNAME = "smb-downloads"
          MAC                = "__MAC_SMB_DL__"
        }
      }
    }

    service {
      name         = "smb-downloads"
      port         = 445
      provider     = "nomad"
      address_mode = "alloc"
      check {
        address_mode = "alloc"
        type         = "tcp"
        port         = 445
        interval     = "30s"
        timeout      = "5s"
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

    task "samba" {
      driver = "podman"

      config {
        image      = "docker.io/dperson/samba:latest"
        args = [
          "-u", "${secret.secrets.user};${secret.secrets.pass}",
          "-s", "qbittorrent;/qbittorrent;yes;no;no",
          "-p",
          "-r"
        ]
      }

      env {
        USERID  = "1000"
        GROUPID = "1000"
      }

      volume_mount {
        volume      = "qbittorrent"
        destination = "/qbittorrent"
      }

      resources {
        cpu    = 100
        memory = 1024
      }
    }
  }
}
