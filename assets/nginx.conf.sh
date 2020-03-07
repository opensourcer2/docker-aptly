#! /bin/bash

cat << EOF > /etc/nginx/conf.d/default.conf
server_names_hash_bucket_size 64;
server {
  root /opt/aptly/public;
  server_name ${HOSTNAME};

  location / {
    autoindex on;
  }  
  location /ui/ {
    try_files $uri $uri/ /ui/index.html;
    autoindex off;
  }
  location /dist/ {
    autoindex on;
  }
  location /pool/ {
    autoindex on;
  }
  location /api/ {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header Host $host;
    proxy_pass http://127.0.0.1:8080;
  }
}
EOF
