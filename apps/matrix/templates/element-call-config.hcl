variable "element_call_config" {
  description = "Element Call config.json"
  default     = <<EOT
{
  "default_server_config": {
    "m.homeserver": {
      "base_url": "https://matrix.__DOMAIN__",
      "server_name": "matrix.__DOMAIN__"
    }
  },
  "livekit": {
    "livekit_service_url": "https://matrix-rtc.__DOMAIN__/livekit/jwt"
  }
}
EOT
}
