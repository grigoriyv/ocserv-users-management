#!/bin/bash

printf "\e[33m########### nginx starting ###########\e[0m \n"

cat <<\EOT >/etc/nginx/conf.d/site.conf
upstream api_backend {
    server ocserv_and_backend:8000;
}
server {
    listen 80;
    location / {
        root /var/www/site;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
    location ~ ^/(api) {
        proxy_pass http://api_backend;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $host;
    }
}
EOT

exec "$@"
