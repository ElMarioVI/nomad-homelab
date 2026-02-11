variable "vaultwarden-conf" {
  default = <<EOT

client_max_body_size 525M;

add_header X-XSS-Protection "1; mode=block" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Access-Control-Allow-Origin "null" always;
add_header Access-Control-Allow-Headers "Content-Type, Authorization, Accept, X-Request-Id, X-Device-Type" always;
add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'wasm-unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob:; font-src 'self'; connect-src 'self' wss:; frame-ancestors 'self'; form-action 'self'; base-uri 'self';" always;

location /metrics {
  return 403;
}

location = /identity/connect/token {
  if ($request_method = 'OPTIONS') {
    add_header Access-Control-Allow-Origin "null" always;
    add_header Access-Control-Allow-Headers "Content-Type, Authorization, Accept, X-Request-Id, X-Device-Type" always;
    add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS" always;
    add_header Access-Control-Max-Age 86400;
    add_header Content-Length 0;
    return 204;
  }
  proxy_pass http://$upstream;
}

location / {
  proxy_pass http://$upstream;
}
EOT
}
