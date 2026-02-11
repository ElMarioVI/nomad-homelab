variable "firewall_config" {
  description = "Config for enshrouded firewall rules"
  default     = <<EOH
FW_ALLOW_IN="0.0.0.0/0:tcp:15637,0.0.0.0/0:udp:15637"
FW_EGRESS="true"
EOH
}
