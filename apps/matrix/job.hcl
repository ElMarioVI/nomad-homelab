job "matrix" {
  type        = "service"
  datacenters = __DATACENTER__

  # ==================== SYNAPSE + POSTGRES ====================
  group "synapse" {

    volume "data" {
      type   = "host"
      source = "matrix-synapse"
    }

    volume "database" {
      type   = "host"
      source = "matrix-postgres"
    }

    service {
      port         = 8008
      address_mode = "alloc"
      name         = "matrix-http"
      provider     = "nomad"
      check {
        address_mode = "alloc"
        type         = "http"
        port         = 8008
        path         = "/health"
        interval     = "30s"
        timeout      = "5s"
      }
      tags = [
        "nginx_enable=true",
        "nginx_domain=matrix.__DOMAIN__",
        "nginx_certificate=__DOMAIN__",
        "nginx_custom_config=matrix",
        "private_access=true"
      ]
    }

    service {
      port         = 8080
      address_mode = "alloc"
      name         = "element-http"
      provider     = "nomad"
      check {
        address_mode = "alloc"
        type         = "http"
        port         = 8080
        path         = "/"
        interval     = "30s"
        timeout      = "5s"
      }
      tags = [
        "nginx_enable=true",
        "nginx_domain=element.__DOMAIN__",
        "nginx_certificate=__DOMAIN__",
        "nginx_custom_config=element",
        "private_access=true"
      ]
    }

    network {
      mode = "cni/containers"
      cni {
        args = {
          NOMAD_JOB_HOSTNAME = "matrix-synapse"
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
        image   = "ghcr.io/elmariovi/net-nomad:latest"
        cap_add = ["NET_ADMIN"]
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

    task "postgres" {
      driver = "podman"

      volume_mount {
        volume      = "database"
        destination = "/var/lib/postgresql"
      }

      config {
        image = "docker.io/postgres:18.1-alpine"
      }

      template {
        data        = <<EOH
POSTGRES_DB=synapse
POSTGRES_USER=synapse
POSTGRES_PASSWORD={{ with nomadVar "nomad/jobs/matrix" }}{{ .db_password }}{{ end }}
POSTGRES_INITDB_ARGS=--encoding=UTF8 --lc-collate=C --lc-ctype=C
EOH
        destination = "local/postgres.env"
        env         = true
      }

      resources {
        cpu    = 500
        memory = 512
      }

      lifecycle {
        hook    = "prestart"
        sidecar = true
      }
    }

    task "synapse" {
      driver = "podman"

      volume_mount {
        volume      = "data"
        destination = "/data"
      }

      config {
        image = "docker.io/matrixdotorg/synapse:v1.147.0"
        volumes = [
          "local/homeserver.yaml:/data/homeserver.yaml:ro",
          "local/log.config:/data/log.config:ro",
        ]
      }

      env {
        SYNAPSE_CONFIG_PATH = "/data/homeserver.yaml"
      }

      template {
        data        = var.homeserver_config
        destination = "local/homeserver.yaml"
        change_mode = "restart"
      }

      template {
        data        = var.log_config
        destination = "local/log.config"
        change_mode = "restart"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }

    task "element" {
      driver = "podman"

      config {
        image = "docker.io/vectorim/element-web:v1.12.10"
        volumes = [
          "local/config.json:/app/config.json:ro",
        ]
      }

      env {
        ELEMENT_WEB_PORT = "8080"
      }

      template {
        data        = var.element_config
        destination = "local/config.json"
        change_mode = "restart"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }

  # ==================== COTURN ====================
  group "coturn" {

    service {
      port         = 3478
      address_mode = "alloc"
      name         = "matrix-turn"
      provider     = "nomad"
    }

    network {
      mode = "cni/containers"
      cni {
        args = {
          NOMAD_JOB_HOSTNAME = "matrix-coturn"
          MAC                = "__MAC_MATRIX__"
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
        image   = "ghcr.io/elmariovi/net-nomad:latest"
        cap_add = ["NET_ADMIN"]
      }
      template {
        data        = var.coturn_firewall_config
        destination = "local/firewall.env"
        env         = true
      }
      resources {
        cpu        = 10
        memory     = 10
        memory_max = 16
      }
    }

    task "coturn" {
      driver = "podman"

      config {
        image = "docker.io/coturn/coturn:4.8.0-alpine"
        volumes = [
          "local/turnserver.conf:/etc/turnserver.conf:ro",
        ]
      }

      template {
        data        = var.coturn_config
        destination = "local/turnserver.conf"
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }

  }

  # ==================== ELEMENT WEB ====================
  # Element runs inside the "synapse" group to share the same network namespace.
  # Synapse API: matrix.__DOMAIN__
  # Element Web: element.__DOMAIN__
}
