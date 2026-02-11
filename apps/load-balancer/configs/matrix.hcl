variable "matrix-conf" {
  default = <<EOT

client_max_body_size 100M;

add_header X-XSS-Protection "1; mode=block" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Content-Security-Policy "default-src 'none'; frame-ancestors 'none';" always;

location = /.well-known/matrix/client {
  default_type application/json;
  add_header Access-Control-Allow-Origin * always;
  return 200 '{"m.homeserver":{"base_url":"https://matrix.__DOMAIN__"}}';
}

location /metrics {
  return 403;
}

location / {
  proxy_pass http://$upstream;
}
EOT
}

variable "matrix-confd" {
  default = ""
}
