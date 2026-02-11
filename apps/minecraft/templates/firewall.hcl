variable "firewall_config" {
  description = "Config for minecraft firewall rules"
  default     = <<EOH
FW_ALLOW_IN="0.0.0.0/0:tcp:25565,0.0.0.0/0:udp:25565"
FW_EGRESS="true"
EOH
}
