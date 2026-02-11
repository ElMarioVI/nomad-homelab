variable "exporter_env" {
  description = "Environment variables for Qbittorrent Exporter"
  default     = <<EOH
QBITTORRENT_BASE_URL=http://127.0.0.1:8080
QBITTORRENT_USERNAME={{ with nomadVar "nomad/jobs/qbittorrent" }}{{ .username }}{{ end }}
QBITTORRENT_PASSWORD={{ with nomadVar "nomad/jobs/qbittorrent" }}{{ .password }}{{ end }}
EOH
}
