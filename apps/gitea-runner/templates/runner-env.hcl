variable "runner_env" {
  description = "Environment variables for Gitea act_runner registration"
  default     = <<EOT
GITEA_INSTANCE_URL=http://{{ range nomadService "gitea-http" }}{{ .Address }}:{{ .Port }}{{ end }}
GITEA_RUNNER_REGISTRATION_TOKEN={{ with nomadVar "nomad/jobs/gitea" }}{{ .runner_token }}{{ end }}
EOT
}
