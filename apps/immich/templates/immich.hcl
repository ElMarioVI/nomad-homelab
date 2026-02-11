variable "immich_environment" {
  default = <<EOT
DB_PASSWORD={{ with nomadVar "nomad/jobs/immich" }}{{ .db_password }}{{ end }}
DB_USERNAME=immich
DB_DATABASE_NAME=immich
DB_HOSTNAME=127.0.0.1
REDIS_HOSTNAME=127.0.0.1
IMMICH_TELEMETRY_INCLUDE=all
EOT
}
