variable "firewall_config" {
  description = "Config for SMB Backups firewall rules"
  default     = <<EOH
FW_ALLOW_IN="{{ env "attr.unique.network.ip-address" }}:tcp:445,{{ with nomadVar "nomad/jobs" }}{{ .home_cidr }}{{ end }}:tcp:445"
FW_ALLOW_OUT="{{ with nomadVar "nomad/jobs" }}{{ .home_cidr }}{{ end }}:tcp"
EOH
}
