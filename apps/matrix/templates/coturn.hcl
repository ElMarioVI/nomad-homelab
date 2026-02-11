variable "coturn_config" {
  description = "Coturn TURN server configuration"
  default     = <<EOT
listening-port=3478
min-port=49152
max-port=49200
use-auth-secret
static-auth-secret={{ with nomadVar "nomad/jobs/matrix" }}{{ .turn_secret }}{{ end }}
realm=matrix.__DOMAIN__
{{ with nomadVar "nomad/jobs/matrix" }}{{ if .external_ip }}external-ip={{ .external_ip }}/{{ env "NOMAD_IP_turn" }}
{{ end }}{{ end }}no-tls
no-dtls
log-file=stdout
EOT
}
