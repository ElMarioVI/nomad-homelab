variable "firewall_config" {
  description = "Config for hytale firewall rules"
  default     = <<EOH
FW_ALLOW_IN="0.0.0.0/0:udp:5520"
FW_EGRESS="true"
EOH
}
