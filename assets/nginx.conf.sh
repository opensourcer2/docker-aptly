#! /bin/bash

cat << EOF > /etc/nginx/conf.d/default.conf
server_names_hash_bucket_size 64;
server {
  root /opt/aptly/public;
  index index.html index.htm;
  server_name ${HOSTNAME};
  autoindex off;

  location / {
    try_files \$uri \$uri/;
    deny all;
  }  
  location /ui/ {
    try_files \$uri \$uri/ /ui/index.html;
    autoindex off;
  }
  location /dist/ {
    autoindex on;
  }
  location /pool/ {
    autoindex on;
  }
  location /api/ {
		proxy_redirect	off;
		proxy_pass	http://localhost:8080/api/;
		proxy_redirect	http://localhost:8080/api/ /api;
		proxy_set_header X-Real-IP \$remote_addr;
		proxy_set_header X-Forwarded-For \$remote_addr;
		proxy_set_header X-Forwarded-Proto \$scheme;
		proxy_set_header Host \$http_host;
		proxy_set_header Origin "";
  }
}
EOF
