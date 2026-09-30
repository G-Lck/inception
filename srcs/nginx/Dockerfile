FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
	nginx \
	curl \
	openssl \
	gettext-base \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/init.sh"]