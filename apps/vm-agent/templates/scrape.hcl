variable "scrape_config" {
  description = "Scrape configuration for the VM agent"
  default     = <<EOH
global:
  scrape_interval: 10s
  scrape_timeout: 5s

scrape_configs:
  - job_name: 'nomad'
    static_configs:
      - targets: ['{{ env "attr.unique.network.ip-address" }}:4646']
    relabel_configs:
      - target_label: instance
        replacement: '{{ env "attr.unique.hostname" }}'
    metrics_path: /v1/metrics?format=prometheus
    scheme: http
    scrape_interval: 10s

  - job_name: 'services'
    nomad_sd_configs:
      - server: 'http://{{ env "attr.unique.network.ip-address" }}:4646'
    relabel_configs:
      - source_labels: [__meta_nomad_node_id]
        regex: '{{ env "node.unique.id" }}'
        action: keep
      - source_labels: [__meta_nomad_tags]
        regex: '.*metrics=true.*'
        action: keep
      - source_labels: [__meta_nomad_service]
        target_label: job
      - target_label: instance
        replacement: '{{ env "attr.unique.hostname" }}'
    metrics_path: /metrics
    scheme: http
    scrape_interval: 10s
    scrape_timeout: 5s

EOH
}
