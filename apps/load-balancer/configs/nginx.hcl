variable "nginx-conf" {
  default = <<EOT
user nginx;
worker_processes auto;
pid /run/nginx.pid;
pcre_jit on;

events {
  worker_connections 4096;
  use epoll;
  multi_accept on;
}

http {
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  types_hash_max_size 2048;

  client_body_timeout 10s;
  client_header_timeout 10s;
  keepalive_timeout 30;
  send_timeout 10s;

  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  map $args $request_string {
    default $request_uri;
    ''      $request_uri;
    *       $request_uri$args;
  }

  log_format main '[$time_local] $remote_addr '
                  '"$host" $request_method "$request_string" $server_protocol $status $body_bytes_sent '
                  'ref="$http_referer" ua="$http_user_agent" '
                  'rt="$request_time" uct="$upstream_connect_time" uht="$upstream_header_time" urt="$upstream_response_time" cache="$upstream_cache_status"';

  access_log /dev/stdout main;
  error_log /dev/stderr;

  ssl_session_cache shared:SSL:15m;
  ssl_session_timeout 1d;
  ssl_session_tickets off;
  ssl_buffer_size 1400;

  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305;
  ssl_ecdh_curve X25519:prime256v1:secp384r1;
  ssl_prefer_server_ciphers off;
  ssl_dhparam /etc/letsencrypt/dhparam.pem;

  add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

  server {
    listen 80 default_server;

    location = /health-check {
      access_log off;
      allow 127.0.0.1/32;
      allow 192.168.0.0/16;
      allow 172.16.0.0/12;
      allow 10.0.0.0/8;
      deny all;
      return 200;
    }

    location / {
      return 301 https://$host$request_uri;
    }
  }

  server {
    listen 443 ssl default_server;
    http2 on;
    ssl_reject_handshake on;
  }

  include /etc/nginx/conf.d/*.conf;

}
EOT
}
