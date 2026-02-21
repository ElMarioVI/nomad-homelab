job "smb-backups" {
  datacenters = __DATACENTER__
  type        = "service"

  secret "secrets" {
    provider = "nomad"
    path     = "nomad/jobs/smb-backups"
  }

  group "smb-backups" {
    volume "disk1" {
      source = "disk1"
      type   = "host"
    }

    volume "disk2" {
      source = "disk2"
      type   = "host"
    }

    volume "disk3" {
      source = "disk3"
      type   = "host"
    }

    volume "disk4" {
      source = "disk4"
      type   = "host"
    }

    volume "disk5" {
      source = "disk5"
      type   = "host"
    }

    network {
      mode = "cni/containers"
      cni {
        args = {
          NOMAD_JOB_HOSTNAME = "smb-backups"
          MAC                = "__MAC_SMB_BK__"
        }
      }
    }

    service {
      name         = "smb-backups"
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
        image      = "ghcr.io/mariojcr/net-nomad:1.0.0"
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
          "-s", "disk1;/disk1;yes;no;no",
          "-s", "disk2;/disk2;yes;no;no",
          "-s", "disk3;/disk3;yes;no;no",
          "-s", "disk4;/disk4;yes;no;no",
          "-s", "disk5;/disk5;yes;no;no",
          "-p",
          "-r"
        ]
      }

      env {
        USERID  = "1000"
        GROUPID = "1000"
      }

      volume_mount {
        volume      = "disk1"
        destination = "/disk1"
      }

      volume_mount {
        volume      = "disk2"
        destination = "/disk2"
      }

      volume_mount {
        volume      = "disk3"
        destination = "/disk3"
      }

      volume_mount {
        volume      = "disk4"
        destination = "/disk4"
      }

      volume_mount {
        volume      = "disk5"
        destination = "/disk5"
      }

      resources {
        cpu    = 100
        memory = 1024
      }
    }
  }
}
