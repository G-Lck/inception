FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
	nginx \
	&& rm -rf /var/lib/apt/lists/*

COPY html/index.html /var/www/html
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

ENTRYPOINT exec nginx -g 'daemon off;'