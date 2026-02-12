variable "matrix-admin-conf" {
  default = <<EOT

add_header X-XSS-Protection "1; mode=block" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "interest-cohort=()" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob: https:; font-src 'self' data:; connect-src 'self' https://matrix.__DOMAIN__ https://matrix-auth.__DOMAIN__ https://api.github.com; frame-ancestors 'none';" always;

location /metrics {
  return 403;
}

location / {
  proxy_pass http://$upstream;
}
EOT
}
