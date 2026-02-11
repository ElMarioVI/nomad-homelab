variable "firewall_config" {
  description = "Config for Qbittorrent firewall rules"
  default     = <<EOH
FW_ALLOW_IN="{{ env "attr.unique.network.ip-address" }}:tcp:8080,{{ range nomadService "load-balancer-http" }}{{ .Address }}:tcp:8080{{ end }},{{ range nomadService "vm-agent" }}{{ if eq .Node (env "node.unique.id") }}{{ .Address }}:tcp:8090{{ end }}{{ end }}"
FW_EGRESS="true"
EOH
}
