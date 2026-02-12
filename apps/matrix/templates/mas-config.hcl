variable "mas_config" {
  description = "Matrix Authentication Service configuration"
  default     = <<EOT
http:
  public_base: "https://matrix-auth.__DOMAIN__/"
  listeners:
    - name: web
      resources:
        - name: discovery
        - name: human
        - name: oauth
        - name: compat
        - name: graphql
          undocumented_oauth2_access: true
        - name: assets
        - name: adminapi
      binds:
        - host: 0.0.0.0
          port: 8080
  trusted_proxies:
    - 192.168.0.0/16
    - 172.16.0.0/12
    - 10.0.0.0/8
    - 127.0.0.0/8

database:
  host: 127.0.0.1
  port: 5432
  username: mas
  password: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .db_password }}{{ end }}"
  database: mas

matrix:
  homeserver: "matrix.__DOMAIN__"
  kind: synapse_modern
  endpoint: "{{ $s := nomadService "matrix-http" }}{{ if $s }}{{ range $s }}http://{{ .Address }}:{{ .Port }}{{ end }}{{ else }}https://matrix.__DOMAIN__{{ end }}"
  secret: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .mas_secret }}{{ end }}"

secrets:
  encryption: "{{ with nomadVar "nomad/jobs/matrix" }}{{ .mas_encryption_key }}{{ end }}"
  keys:
    - kid: "rsa-key"
      key_file: /data/keys/rsa.pem
    - kid: "ecdsa-key"
      key_file: /data/keys/ecdsa.pem

passwords:
  enabled: true
  minimum_complexity: 3
  schemes:
    - version: 2
      algorithm: argon2id

account:
  password_registration_enabled: true
  password_registration_email_required: false
  registration_token_required: true
  displayname_change_allowed: true
  password_change_allowed: true

email:
  from: '"Matrix Auth" <auth@__DOMAIN__>'
  transport: blackhole

branding:
  service_name: "Matrix Auth"

telemetry:
  metrics:
    exporter: prometheus
  tracing:
    exporter: none
EOT
}
