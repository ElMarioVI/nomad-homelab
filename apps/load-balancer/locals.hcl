locals {
  files = [
    {
      data        = var.nginx-conf
      destination = "local/nginx.conf"
    },
    {
      data          = var.vhosts-confd
      destination   = "local/conf.d/vhosts.conf"
      change_mode   = "signal"
      change_signal = "SIGHUP"
    },
    {
      data        = var.minimal-conf
      destination = "local/conf/minimal.conf"
    },
    {
      data        = var.jellyfin-confd
      destination = "local/conf.d/jellyfin.conf"
    },
    {
      data        = var.jellyfin-conf
      destination = "local/conf/jellyfin.conf"
    },
    {
      data        = var.gitea-conf
      destination = "local/conf/gitea.conf"
    },
    {
      data        = var.vaultwarden-conf
      destination = "local/conf/vaultwarden.conf"
    },
    {
      data        = var.immich-conf
      destination = "local/conf/immich.conf"
    },
    {
      data        = var.grafana-conf
      destination = "local/conf/grafana.conf"
    },
    {
      data        = var.matrix-conf
      destination = "local/conf/matrix.conf"
    },
    {
      data        = var.element-conf
      destination = "local/conf/element.conf"
    }
  ]
}
