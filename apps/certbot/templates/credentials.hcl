variable "credentials_ini" {
  description = "INI file with credentials for Certbot"
  default     = <<EOH
{{ with nomadVar "nomad/jobs/certbot" }}
dns_ovh_endpoint = "ovh-eu"
dns_ovh_application_key = {{ .app_key }}
dns_ovh_application_secret = {{ .app_secret }}
dns_ovh_consumer_key = {{ .consumer_key }}
{{ end }}
EOH
}
