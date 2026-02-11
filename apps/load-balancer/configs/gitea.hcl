variable "gitea-conf" {
  default = <<EOT

add_header X-XSS-Protection "1; mode=block" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;
add_header Permissions-Policy "accelerometer=(), autoplay=(), camera=(), display-capture=(), encrypted-media=(), fullscreen=(self), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), midi=(), payment=(), picture-in-picture=(), publickey-credentials-get=(), screen-wake-lock=(), usb=(), xr-spatial-tracking=()" always;
add_header Content-Security-Policy "default-src 'none'; script-src 'self' 'unsafe-inline' https://www.gstatic.com/; connect-src 'self'; img-src 'self' data:; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com/css2; font-src 'self' data: https://fonts.gstatic.com; manifest-src 'self' data:;" always;

location / {
  client_max_body_size 512M;
  proxy_pass http://$upstream;
}
EOT
}
