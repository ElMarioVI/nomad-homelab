variable "runner_config" {
  description = "YAML configuration for Gitea act_runner (host executor, no Docker socket)"
  default     = <<EOT
log:
  level: "info"

runner:
  labels:
    - "self-hosted:host"
    - "ubuntu-latest:host"
    - "ubuntu-22.04:host"
    - "linux:host"
  capacity: 1
  timeout: 3h
  fetch_interval: 2s
  fetch_timeout: 5s

container:
  # "-" desactiva la búsqueda de Docker socket al arrancar el daemon
  docker_host: "-"

host:
  workdir_parent: "/tmp/act-runner-workdir"

cache:
  enabled: false
EOT
}
