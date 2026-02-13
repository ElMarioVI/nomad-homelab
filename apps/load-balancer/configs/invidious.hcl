variable "invidious-conf" {
  default = <<EOT

add_header X-XSS-Protection "1; mode=block" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;
add_header Permissions-Policy "accelerometer=(), autoplay=(self), camera=(), display-capture=(), encrypted-media=(self), fullscreen=(self), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), midi=(), payment=(), picture-in-picture=(self), publickey-credentials-get=(), screen-wake-lock=(), usb=(), xr-spatial-tracking=()" always;

proxy_set_header Accept-Encoding "";

location /metrics {
  return 403;
}

location / {
  if ($request_method = OPTIONS) {
    add_header Access-Control-Allow-Origin "https://youtube.__DOMAIN__" always;
    add_header Access-Control-Allow-Methods "GET, POST, OPTIONS, HEAD, PATCH, PUT, DELETE" always;
    add_header Access-Control-Allow-Headers "User-Agent, Authorization, Content-Type" always;
    add_header Access-Control-Max-Age 1728000;
    add_header Content-Length 0;
    add_header Content-Type "text/plain charset=UTF-8";
    return 204;
  }

  proxy_hide_header Access-Control-Allow-Origin;
  add_header Access-Control-Allow-Credentials true always;
  add_header Access-Control-Allow-Origin "https://youtube.__DOMAIN__" always;
  add_header Access-Control-Allow-Methods "GET, POST, OPTIONS, HEAD, PATCH, PUT, DELETE" always;
  add_header Access-Control-Allow-Headers "User-Agent, Authorization, Content-Type" always;

  proxy_pass http://$upstream;
  proxy_buffering off;
}
EOT
}
