variable "firewall_config" {
  description = "Config for Node Exporter firewall rules"
  default     = <<EOH
FW_ALLOW_IN="{{ env "attr.unique.network.ip-address" }}:tcp:9100,{{ range nomadService "vm-agent" }}{{ if eq .Node (env "node.unique.id") }}{{ .Address }}:tcp:9100{{ end }}{{ end }}"
EOH
}
