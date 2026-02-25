variable "matrix-call-conf" {
  default = <<EOT

add_header X-XSS-Protection "1; mode=block" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "accelerometer=(), autoplay=(self), camera=(self), display-capture=(self), encrypted-media=(self), fullscreen=(self), geolocation=(), gyroscope=(), magnetometer=(), microphone=(self), midi=(), payment=(), picture-in-picture=(self), publickey-credentials-get=(), screen-wake-lock=(), usb=(), xr-spatial-tracking=()" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-eval' blob:; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob: https:; font-src 'self' data:; connect-src 'self' https://matrix.__DOMAIN__ wss://matrix.__DOMAIN__ https://matrix-auth.__DOMAIN__ wss://matrix-rtc.__DOMAIN__ https://matrix-rtc.__DOMAIN__; media-src 'self' blob:; worker-src 'self' blob:; frame-ancestors https://matrix-web.__DOMAIN__;" always;

location /metrics {
  return 403;
}

location / {
  proxy_pass http://$upstream;
}
EOT
}
