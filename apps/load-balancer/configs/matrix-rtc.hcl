variable "matrix-rtc-confd" {
  default = <<EOT
{{- range nomadService "livekit-jwt" }}
upstream livekit-jwt {
  server {{ .Address }}:{{ .Port }} max_fails=3 fail_timeout=5s;
  keepalive 512;
}
{{- end }}
EOT
}

variable "matrix-rtc-conf" {
  default = <<EOT

add_header X-XSS-Protection "1; mode=block" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;

# JWT service
location ^~ /livekit/jwt/ {
  set $jwt_upstream livekit-jwt;
  proxy_pass http://$jwt_upstream/;
}

# LiveKit SFU WebSocket
location ^~ /livekit/sfu/ {
  proxy_send_timeout 120;
  proxy_read_timeout 120;
  proxy_buffering off;
  proxy_pass http://$upstream/;
}

location / {
  return 404;
}
EOT
}
