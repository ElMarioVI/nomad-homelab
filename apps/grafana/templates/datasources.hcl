variable "datasources_config" {
  description = "Config for Grafana datasources"
  default     = <<EOH
apiVersion: 1
datasources:
  - name: VictoriaMetrics
    uid: P4169E866C3094E38
    type: prometheus
    url: http://{{ range nomadService "vm-server" }}{{ .Address }}:{{ .Port }}{{ end }}
    access: proxy
    isDefault: true
    editable: true
EOH
}
