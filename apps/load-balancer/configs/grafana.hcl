variable "grafana-conf" {
  default = <<EOT

add_header X-XSS-Protection "1; mode=block" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;
add_header Permissions-Policy "accelerometer=(), autoplay=(), camera=(), display-capture=(), encrypted-media=(), fullscreen=(self), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), midi=(), payment=(), picture-in-picture=(), publickey-credentials-get=(), screen-wake-lock=(), usb=(), xr-spatial-tracking=()" always;
add_header Content-Security-Policy "default-src 'self' 'unsafe-eval' 'unsafe-inline' data: https:;" always;

location /metrics {
  return 403;
}

location / {
  proxy_pass http://$upstream;
}
EOT
}
