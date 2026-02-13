variable "firewall_config" {
  description = "Config for Invidious firewall rules"
  default     = <<EOH
FW_DNS="{{ with nomadVar "nomad/jobs" }}{{ .dns_server_address }}{{ end }}"
FW_ALLOW_IN="{{ env "attr.unique.network.ip-address" }}:tcp:3000,{{ env "attr.unique.network.ip-address" }}:tcp:80,{{ env "attr.unique.network.ip-address" }}:tcp:8282,{{ env "attr.unique.network.ip-address" }}:tcp:3004,{{ range nomadService "load-balancer-http" }}{{ .Address }}:tcp:3000,{{ .Address }}:tcp:80,{{ .Address }}:tcp:8282,{{ .Address }}:tcp:3004{{ end }}"
FW_ALLOW_OUT="0.0.0.0/0:tcp:443,0.0.0.0/0:tcp:80"
EOH
}

variable "database_env" {
  description = "Database environment variables"
  default     = <<EOH
POSTGRES_DB=invidious
POSTGRES_USER={{ with nomadVar "nomad/jobs/invidious" }}{{ .db_user }}{{ end }}
POSTGRES_PASSWORD={{ with nomadVar "nomad/jobs/invidious" }}{{ .db_password }}{{ end }}
EOH
}

variable "companion_env" {
  description = "Invidious Companion environment variables"
  default     = <<EOH
SERVER_SECRET_KEY={{ with nomadVar "nomad/jobs/invidious" }}{{ .companion_key }}{{ end }}
EOH
}

variable "materialious_env" {
  description = "Materialious environment variables"
  default     = <<EOH
VITE_DEFAULT_INVIDIOUS_INSTANCE=https://invidious.__DOMAIN__
VITE_DEFAULT_COMPANION_INSTANCE=https://companion.__DOMAIN__/companion
VITE_DEFAULT_RETURNYTDISLIKES_INSTANCE=https://returnyoutubedislikeapi.com
VITE_DEFAULT_SPONSERBLOCK_INSTANCE=https://sponsor.ajay.app
VITE_DEFAULT_DEARROW_INSTANCE=https://sponsor.ajay.app
VITE_DEFAULT_DEARROW_THUMBNAIL_INSTANCE=https://dearrow-thumb.ajay.app
VITE_DEFAULT_API_EXTENDED_INSTANCE=https://api-extended.__DOMAIN__
VITE_DEFAULT_SETTINGS='{"darkMode":true,"themeColor":"#ff0000","amoledTheme":false,"region":"ES","searchSuggestions":true,"returnYtDislikes":true,"sponsorBlock":true,"sponsorBlockCategoriesv2":{"sponsor":"automatic","selfpromo":"automatic","interaction":"manual"},"sponsorBlockDisplayToast":true,"deArrowEnabled":true,"miniplayerEnabled":true,"savePlaybackPosition":true,"autoplayNextByDefault":true,"autoPlay":true,"defaultQuality":"1080","showWarning":false,"displayThumbnailAvatars":true,"syncious":true,"synciousInstance":"https://api-extended.__DOMAIN__"}'
EOH
}

variable "api_extended_env" {
  description = "API Extended environment variables"
  default     = <<EOH
api_extended_postgre='{"host": "localhost", "port": 5432, "database": "invidious", "user": "{{ with nomadVar "nomad/jobs/invidious" }}{{ .db_user }}{{ end }}", "password": "{{ with nomadVar "nomad/jobs/invidious" }}{{ .db_password }}{{ end }}"}'
api_extended_allowed_origins='["https://youtube.__DOMAIN__"]'
api_extended_debug=false
api_extended_invidious_instance=https://invidious.__DOMAIN__
api_extended_production_instance=https://api-extended.__DOMAIN__
WEB_CONCURRENCY=2
PORT=3004
EOH
}

variable "invidious_config" {
  description = "Invidious configuration file"
  default     = <<EOH
db:
  dbname: invidious
  user: {{ with nomadVar "nomad/jobs/invidious" }}{{ .db_user }}{{ end }}
  password: {{ with nomadVar "nomad/jobs/invidious" }}{{ .db_password }}{{ end }}
  host: localhost
  port: 5432

check_tables: true

hmac_key: "{{ with nomadVar "nomad/jobs/invidious" }}{{ .hmac_key }}{{ end }}"

invidious_companion:
  - private_url: "http://localhost:8282/companion"
    public_url: "https://companion.__DOMAIN__/companion"

invidious_companion_key: "{{ with nomadVar "nomad/jobs/invidious" }}{{ .companion_key }}{{ end }}"

external_port: 443
domain: invidious.__DOMAIN__
https_only: true

registration_enabled: false
login_enabled: false

use_innertube_for_captions: true
enable_user_notifications: false
statistics_enabled: false
popular_enabled: true

default_user_preferences:
  locale: es
  region: ES
  player_style: youtube
  quality: dash
  quality_dash: auto
  dark_mode: dark
  thin_mode: false
  autoplay: true
  continue: true
  continue_autoplay: true
  save_player_pos: true
  local: true
  related_videos: true
  annotations: false
  extend_desc: false
  vr_mode: false
  volume: 100
  speed: 1.0
  preload: true
  comments:
    - youtube
    - ""

EOH
}
