variable "livekit_config" {
  description = "LiveKit server configuration"
  default     = <<EOT
port: 7880
log_level: info

rtc:
  tcp_port: 7881
  port_range_start: 50000
  port_range_end: 60000
  use_external_ip: true

keys:
  livekit-key: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .livekit_secret }}{{ end }}"

room:
  auto_create: true
  empty_timeout: 300
  departure_timeout: 20
EOT
}
