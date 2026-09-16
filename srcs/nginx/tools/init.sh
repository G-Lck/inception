#!/bin/sh

set -e

DOMAIN_NAME=${DOMAIN_NAME:-glucken.42.ch}
WORDPRESS_PATH=${WORDPRESS_PATH:-/var/www/wordpress}
WORDPRESS_CONTAINER_NAME=${WORDPRESS_CONTAINER_NAME:-wordpress}

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/key.pem \
	-out /etc/nginx/ssl/cert.pem \
	-subj "/C=CH/ST=Geneva/L=Geneva/O=42/OU=Inception/CN=${DOMAIN_NAME}"

envsubst '${DOMAIN_NAME} ${WORDPRESS_PATH} ${WORDPRESS_CONTAINER_NAME}' \
	< /etc/nginx/nginx.conf.template \
	> /etc/nginx/nginx.conf

exec nginx -g 'daemon off;'