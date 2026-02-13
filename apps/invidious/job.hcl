job "invidious" {
  type        = "service"
  datacenters = __DATACENTER__

  group "invidious" {
    volume "database" {
      type   = "host"
      source = "invidious-database"
    }

    service {
      port         = 3000
      address_mode = "alloc"
      name         = "invidious-http"
      provider     = "nomad"
      check {
        address_mode = "alloc"
        type         = "http"
        path         = "/"
        interval     = "30s"
        timeout      = "5s"
      }
      tags = [
        "nginx_enable=true",
        "nginx_domain=invidious.__DOMAIN__",
        "nginx_certificate=__DOMAIN__",
        "nginx_custom_config=invidious",
        "private_access=true"
      ]
    }

    service {
      port         = 80
      address_mode = "alloc"
      name         = "materialious-http"
      provider     = "nomad"
      check {
        address_mode = "alloc"
        type         = "http"
        path         = "/"
        interval     = "30s"
        timeout      = "5s"
      }
      tags = [
        "nginx_enable=true",
        "nginx_domain=youtube.__DOMAIN__",
        "nginx_certificate=__DOMAIN__",
        "nginx_custom_config=materialious",
        "private_access=true"
      ]
    }

    service {
      port         = 8282
      address_mode = "alloc"
      name         = "companion-http"
      provider     = "nomad"
      check {
        address_mode = "alloc"
        type         = "tcp"
        interval     = "30s"
        timeout      = "5s"
      }
      tags = [
        "nginx_enable=true",
        "nginx_domain=companion.__DOMAIN__",
        "nginx_certificate=__DOMAIN__",
        "nginx_custom_config=invidious",
        "private_access=true"
      ]
    }

    service {
      port         = 3004
      address_mode = "alloc"
      name         = "api-extended-http"
      provider     = "nomad"
      check {
        address_mode = "alloc"
        type         = "http"
        path         = "/schema"
        interval     = "30s"
        timeout      = "5s"
      }
      tags = [
        "nginx_enable=true",
        "nginx_domain=api-extended.__DOMAIN__",
        "nginx_certificate=__DOMAIN__",
        "nginx_custom_config=invidious",
        "private_access=true"
      ]
    }

    network {
      mode = "cni/containers"
      cni {
        args = {
          NOMAD_JOB_HOSTNAME = "invidious-services"
          MAC                = "__MAC_INVIDIOUS__"
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

    task "database" {
      driver = "podman"
      lifecycle {
        hook    = "prestart"
        sidecar = true
      }

      volume_mount {
        volume      = "database"
        destination = "/var/lib/postgresql"
      }

      config {
        image = "docker.io/postgres:18-alpine"
      }

      template {
        data        = var.database_env
        destination = "local/db.env"
        env         = true
      }

      resources {
        cpu    = 200
        memory = 256
      }
    }

    task "companion" {
      driver = "podman"

      config {
        image     = "quay.io/invidious/invidious-companion:master-607cb8d"
      }

      template {
        data        = var.companion_env
        destination = "secrets/companion.env"
        env         = true
      }

      resources {
        cpu    = 500
        memory = 1024
      }
    }

    task "materialious" {
      driver = "podman"

      config {
        image = "docker.io/wardpearce/materialious:1.14.4"
      }

      template {
        data        = var.materialious_env
        destination = "local/materialious.env"
        env         = true
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }

    task "api-extended" {
      driver = "podman"

      config {
        image = "docker.io/wardpearce/invidious_api_extended:latest"
      }

      template {
        data        = var.api_extended_env
        destination = "local/api-extended.env"
        env         = true
      }

      resources {
        cpu    = 200
        memory = 256
      }
    }

    task "invidious" {
      driver = "podman"

      config {
        image = "quay.io/invidious/invidious:2026.02.07-11db343"
      }

      template {
        data        = var.invidious_config
        destination = "local/config.yml"
      }

      env {
        INVIDIOUS_CONFIG_FILE = "/local/config.yml"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
