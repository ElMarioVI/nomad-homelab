variable "firewall_config" {
  description = "Config for Matrix Synapse firewall rules"
  default     = <<EOH
FW_DNS="{{ with nomadVar "nomad/jobs" }}{{ .dns_server_address }}{{ end }}"
FW_ALLOW_IN="{{ env "attr.unique.network.ip-address" }}:tcp:8008,{{ env "attr.unique.network.ip-address" }}:tcp:8080,{{ range nomadService "load-balancer-http" }}{{ .Address }}:tcp:8008{{ end }},{{ range nomadService "load-balancer-http" }}{{ .Address }}:tcp:8080{{ end }}"
EOH
}

variable "coturn_firewall_config" {
  description = "Config for Coturn TURN server firewall rules"
  default     = <<EOH
FW_ALLOW_IN="0.0.0.0/0:tcp:3478,0.0.0.0/0:udp"
EOH
}
