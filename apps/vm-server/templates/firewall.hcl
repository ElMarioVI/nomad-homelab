variable "firewall_config" {
  description = "Config for VM Server firewall rules"
  default     = <<EOH
FW_ALLOW_IN="{{ env "attr.unique.network.ip-address" }}:tcp:8428,{{ range nomadService "vm-agent" }}{{ .Address }}:tcp:8428,{{ end }}{{ range nomadService "grafana" }}{{ .Address }}:tcp:8428{{ end }}"
EOH
}
