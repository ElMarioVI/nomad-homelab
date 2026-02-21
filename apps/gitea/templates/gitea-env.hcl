variable "gitea_env" {
  description = "Environment variables for Gitea server"
  default     = <<EOT
# Base de datos
GITEA__database__DB_TYPE=postgres
GITEA__database__HOST=127.0.0.1:5432
GITEA__database__NAME=gitea
GITEA__database__USER=gitea
GITEA__database__PASSWD={{ with nomadVar "nomad/jobs/gitea" }}{{ .db_password }}{{ end }}

# Servidor web
GITEA__server__DOMAIN=git.__DOMAIN__
GITEA__server__ROOT_URL=https://git.__DOMAIN__/
GITEA__server__HTTP_PORT=3000

# SSH integrado
GITEA__server__SSH_DOMAIN=git.__DOMAIN__
GITEA__server__SSH_PORT=2222
GITEA__server__SSH_LISTEN_PORT=2222
GITEA__server__START_SSH_SERVER=true
GITEA__server__BUILTIN_SSH_SERVER_USER=git

# Registro de paquetes (incluye Docker/OCI)
GITEA__packages__ENABLED=true

# Actions (CI/CD)
GITEA__actions__ENABLED=true
GITEA__actions__DEFAULT_ACTIONS_URL=https://github.com

# Seguridad
GITEA__security__INSTALL_LOCK=true
GITEA__security__SECRET_KEY={{ with nomadVar "nomad/jobs/gitea" }}{{ .secret_key }}{{ end }}
GITEA__security__INTERNAL_TOKEN={{ with nomadVar "nomad/jobs/gitea" }}{{ .internal_token }}{{ end }}

# Datos en volumen montado
GITEA__repository__ROOT=/data/gitea/repositories
GITEA__log__ROOT_PATH=/data/gitea/log
GITEA__server__APP_DATA_PATH=/data/gitea
EOT
}

