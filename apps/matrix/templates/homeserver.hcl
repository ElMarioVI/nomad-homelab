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
      - names: [client, federation]
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
    keepalives: 1
    keepalives_idle: 10
    keepalives_interval: 10
    keepalives_count: 3
    application_name: synapse

log_config: "/data/log.config"
media_store_path: /data/media_store
uploads_path: /data/uploads
max_upload_size: 100M

# Proteccion SSRF global
ip_range_blacklist:
  - 127.0.0.0/8
  - 10.0.0.0/8
  - 172.16.0.0/12
  - 192.168.0.0/16
  - 100.64.0.0/10
  - 192.0.0.0/24
  - 169.254.0.0/16
  - 192.88.99.0/24
  - 198.18.0.0/15
  - 192.0.2.0/24
  - 198.51.100.0/24
  - 203.0.113.0/24
  - 224.0.0.0/4
  - "::1/128"
  - "fe80::/10"
  - "fc00::/7"
  - "2001:db8::/32"
  - "ff00::/8"
  - "fec0::/10"

# Previsualizacion de URLs en chats
url_preview_enabled: true
url_preview_ip_range_blacklist:
  - 127.0.0.0/8
  - 10.0.0.0/8
  - 172.16.0.0/12
  - 192.168.0.0/16
  - 100.64.0.0/10
  - 192.0.0.0/24
  - 169.254.0.0/16
  - 192.88.99.0/24
  - 198.18.0.0/15
  - 192.0.2.0/24
  - 198.51.100.0/24
  - 203.0.113.0/24
  - 224.0.0.0/4
  - "::1/128"
  - "fe80::/10"
  - "fc00::/7"
  - "2001:db8::/32"
  - "ff00::/8"
  - "fec0::/10"

# Autenticacion gestionada por MAS
password_config:
  localdb_enabled: false
  enabled: false

require_auth_for_profile_requests: true
federation_client_minimum_tls_version: '1.2'

# Registro administrado por MAS; shared_secret para admin API
registration_shared_secret: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .registration_secret }}{{ end }}"

# Matrix Authentication Service
matrix_authentication_service:
  enabled: true
  issuer: "https://matrix-auth.__DOMAIN__/"
  account_management_url: "https://matrix-auth.__DOMAIN__/account"
  endpoint: "{{ $s := nomadService "mas-http" }}{{ if $s }}{{ range $s }}http://{{ .Address }}:{{ .Port }}/{{ end }}{{ else }}https://matrix-auth.__DOMAIN__/{{ end }}"
  secret: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .mas_secret }}{{ end }}"

# Federacion desactivada
federation_domain_whitelist: []

# Push notifications via push.element.io (default en clientes oficiales)
push:
  enabled: true
  include_content: true
  group_unread_count_by_room: true

# Features experimentales para experiencia moderna tipo Discord
experimental_features:
  # === LiveKit/RTC (llamadas y video) ===
  msc3266_enabled: true                    # Room summary API
  msc4028_push_encrypted_events: true      # Push notifications cifradas
  msc4108_enabled: true                    # Login con QR + E2EE (LiveKit)
  msc4143_enabled: true                    # MatrixRTC con backend LiveKit
  msc4222_enabled: true                    # state_after en sync v2

  # === Hilos y Mensajería ===
  msc2654_enabled: true                    # Contadores de mensajes no leídos mejorados
  msc1767_enabled: true                    # Extensible Events - mensajes más ricos
  msc3874_enabled: true                    # Filtrado de mensajes por tipo de relación

  # === Notificaciones y Control ===
  msc3890_enabled: true                    # Silenciar notificaciones remotamente
  msc3391_enabled: true                    # Eliminar account data (requerido para msc3890)
  msc3881_enabled: true                    # Control remoto de notificaciones push

  # === Privacidad y Moderación ===
  msc2815_enabled: true                    # Moderadores pueden ver contenido redactado
  msc3852_enabled: true                    # Ver último user agent en dispositivos
  msc3720_enabled: true                    # Endpoint de estado de cuenta

  # === Social y Presencia ===
  msc3026_enabled: true                    # Estado de presencia "ocupado" (busy)
  msc2666_enabled: true                    # Ver salas mutuas entre usuarios

max_event_delay_duration: 24h

rc_message:
  per_second: 0.5
  burst_count: 30

rc_delayed_event_mgmt:
  per_second: 1
  burst_count: 20

extra_well_known_client_content:
  "org.matrix.msc4143.rtc_foci":
    - type: "livekit"
      livekit_service_url: "https://matrix-rtc.__DOMAIN__/livekit/jwt"

macaroon_secret_key: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .macaroon_secret }}{{ end }}"
form_secret: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .form_secret }}{{ end }}"

signing_key_path: "/data/signing.key"
trusted_key_servers: []
suppress_key_server_warning: true

# Cifrado E2EE por defecto en salas nuevas
encryption_enabled_by_default_for_room_type: all

# Directorio de usuarios: buscar todos los usuarios locales
user_directory:
  search_all_users: true
  prefer_local_users: true

# Presencia online/offline
presence:
  enabled: true

auto_join_rooms:
  - "#general:matrix.__DOMAIN__"
autocreate_auto_join_rooms: true

report_stats: false
EOT
}
