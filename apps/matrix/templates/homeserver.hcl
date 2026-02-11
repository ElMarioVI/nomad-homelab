variable "homeserver_config" {
  description = "Synapse homeserver.yaml configuration"
  default     = <<EOT
server_name: "matrix.__DOMAIN__"
public_baseurl: "https://matrix.__DOMAIN__"
pid_file: /data/homeserver.pid
serve_server_wellknown: true

listeners:
  - port: 8008
    type: http
    tls: false
    x_forwarded: true
    resources:
      - names: [client]
        compress: false

database:
  name: psycopg2
  args:
    user: synapse
    password: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .db_password }}{{ end }}"
    database: synapse
    host: 127.0.0.1
    port: 5432
    cp_min: 5
    cp_max: 10

log_config: "/data/log.config"
media_store_path: /data/media_store
uploads_path: /data/uploads
max_upload_size: 100M
url_preview_enabled: false

enable_registration: true
enable_registration_without_verification: true
registration_shared_secret: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .registration_secret }}{{ end }}"

# Federacion desactivada
federation_domain_whitelist: []

# TURN para llamadas de voz/video
turn_uris:
  {{- range nomadService "matrix-turn" }}
  - "turn:{{ .Address }}:{{ .Port }}?transport=udp"
  - "turn:{{ .Address }}:{{ .Port }}?transport=tcp"
  {{- end }}
turn_shared_secret: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .turn_secret }}{{ end }}"
turn_user_lifetime: 86400000
turn_allow_guests: false

macaroon_secret_key: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .macaroon_secret }}{{ end }}"
form_secret: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .form_secret }}{{ end }}"

signing_key_path: "/data/signing.key"
trusted_key_servers: []
suppress_key_server_warning: true

auto_join_rooms:
  - "#general:matrix.__DOMAIN__"
autocreate_auto_join_rooms: true

report_stats: false
EOT
}
