variable "matrix-auth-conf" {
  default = <<EOT

add_header X-XSS-Protection "1; mode=block" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;

location /metrics {
  return 403;
}

location / {
  proxy_pass http://$upstream;
}
EOT
}
