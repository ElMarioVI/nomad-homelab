locals {
  config_files = [
    {
      data        = var.grafana-env
      destination = "local/grafana.env"
      env         = true
    },
    {
      data        = var.datasources_config
      destination = "local/provisioning/datasources/prometheus.yml"
    },
    {
      data        = var.dashboards_provisioning
      destination = "local/provisioning/dashboards/dashboards.yml"
    },
  ]

  dashboard_files = [
    {
      data        = var.dashboard_node_exporter_full
      destination = "local/dashboards/node-exporter-full.json"
    },
    {
      data        = var.dashboard_nomad_allocations
      destination = "local/dashboards/nomad-allocations.json"
    },
    {
      data        = var.dashboard_nomad_clients
      destination = "local/dashboards/nomad-clients.json"
    },
    {
      data        = var.dashboard_nomad_server
      destination = "local/dashboards/nomad-server.json"
    },
    {
      data        = var.dashboard_qbittorrent
      destination = "local/dashboards/qbittorrent.json"
    },
    {
      data        = var.dashboard_victoriametrics_single
      destination = "local/dashboards/victoriametrics-single.json"
    },
    {
      data        = var.dashboard_victoriametrics_vmagent
      destination = "local/dashboards/victoriametrics-vmagent.json"
    },
    {
      data        = var.dashboard_jellyfin
      destination = "local/dashboards/jellyfin.json"
    },
    {
      data        = var.dashboard_immich
      destination = "local/dashboards/immich.json"
    },
  ]
}
