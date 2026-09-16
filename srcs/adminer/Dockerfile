FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
	php-cli \
	php-mysqli \
	curl \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && \
	curl -o /var/www/html/index.php \
	https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

WORKDIR /var/www/html

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]