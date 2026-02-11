variable "immich-conf" {
  default = <<EOT

add_header X-XSS-Protection "1; mode=block" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;

client_max_body_size 50000M;

location /metrics {
  return 403;
}

location / {
  proxy_pass http://$upstream;
}
EOT
}
