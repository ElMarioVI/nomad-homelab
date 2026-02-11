variable "dashboards_provisioning" {
  description = "Config for Grafana dashboard provisioning"
  default     = <<EOH
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 30
    options:
      path: /local/dashboards
EOH
}
