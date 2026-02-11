variable "vaultwarden_env" {
  description = "Environment variables for Vaultwarden"
  default     = <<EOH
ADMIN_TOKEN={{ with nomadVar "nomad/jobs/vaultwarden" }}{{ .admin_token }}{{ end }}
SMTP_HOST="smtp.gmail.com"
SMTP_USERNAME={{ with nomadVar "nomad/jobs/vaultwarden" }}{{ .smtp_mail }}{{ end }}
SMTP_PASSWORD={{ with nomadVar "nomad/jobs/vaultwarden" }}{{ .smtp_password }}{{ end }}
SMTP_FROM={{ with nomadVar "nomad/jobs/vaultwarden" }}{{ .smtp_mail }}{{ end }}
EOH
}
