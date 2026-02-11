variable "firewall_config" {
  description = "Config for VM Agent firewall rules"
  default     = <<EOH
FW_ALLOW_IN="{{ env "attr.unique.network.ip-address" }}:tcp:8429"
FW_ALLOW_OUT="{{ range nomadService "vm-server" }}{{ .Address }}:tcp:{{ .Port }},{{ end }}{{ range nomadServices }}{{ range nomadService .Name }}{{ if and (eq .Node (env "node.unique.id")) (.Tags | contains "metrics=true") }}{{ .Address }}:tcp:{{ .Port }},{{ end }}{{ end }}{{ end }}{{ env "attr.unique.network.ip-address" }}:tcp:4646"
EOH
}
