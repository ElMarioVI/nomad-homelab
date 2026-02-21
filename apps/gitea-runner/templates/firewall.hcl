variable "firewall_config" {
  description = "Config for Gitea runner firewall rules"
  default     = <<EOH
FW_DNS="{{ with nomadVar "nomad/jobs" }}{{ .dns_server_address }}{{ end }}"
FW_ALLOW_IN="{{ env "attr.unique.network.ip-address" }}:tcp:8080"
FW_ALLOW_OUT="{{ range nomadService "gitea-http" }}{{ .Address }}:tcp:{{ .Port }},{{ end }}0.0.0.0/0:tcp:443,0.0.0.0/0:tcp:80,0.0.0.0/0:tcp:22"
EOH
}
