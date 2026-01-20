#!/bin/bash
yum update -y
yum install -y nginx openssl

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/nginx.key \
  -out /etc/nginx/ssl/nginx.crt \
  -subj "/C=PK/ST=Punjab/L=Islamabad/O=Terraform/OU=Dev/CN=localhost"

cat <<EOF > /etc/nginx/conf.d/ssl.conf
server {
    listen 443 ssl;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}

server {
    listen 80;
    return 301 https://\$host\$request_uri;
}
EOF

echo "<h1>This is Tehreem Khan's Terraform environment</h1>" > /usr/share/nginx/html/index.html

systemctl enable nginx
systemctl restart nginx
