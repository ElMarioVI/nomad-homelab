variable "element_config" {
  description = "Element Web config.json"
  default     = <<EOT
{
  "default_server_config": {
    "m.homeserver": {
      "base_url": "https://matrix.__DOMAIN__",
      "server_name": "matrix.__DOMAIN__"
    }
  },
  "brand": "Element",
  "disable_guests": true,
  "disable_3pid_login": true,
  "default_theme": "dark",
  "room_directory": {
    "servers": ["matrix.__DOMAIN__"]
  }
}
EOT
}
