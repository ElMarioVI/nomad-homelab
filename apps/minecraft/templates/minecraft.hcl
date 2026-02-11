variable "minecraft_env" {
  description = "Environment variables for Minecraft server"
  default     = <<EOH
EULA=TRUE
TYPE=AUTO_CURSEFORGE
CF_SLUG=prominence-2-hasturian-era
MOTD=Life is MMO
DIFFICULTY=2
MAX_PLAYERS=100
VIEW_DISTANCE=16
SPAWN_PROTECTION=0
PREVENT_PROXY_CONNECTIONS=true
MEMORY=8192M
USE_AIKAR_FLAGS=true
CF_API_KEY={{ with nomadVar "nomad/jobs/minecraft" }}{{ .curse_forge_api_key }}{{ end }}
EOH
}
