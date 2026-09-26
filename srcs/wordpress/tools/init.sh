#!/bin/bash

set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
wp_queen_password=$(cat /run/secrets/wp_queen_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

WORDPRESS_PATH=${WORDPRESS_PATH:-/var/www/wordpress}
DB_NAME=${DB_NAME:-wordpress}
DB_USER=${DB_USER:-wpuser}
DB_HOST=${DB_HOST:-mariadb}
WP_URL=${WP_URL:-https://glucken.42.ch}
WP_TITLE=${WP_TITLE:-Inception}
WP_QUEEN_USER=${WP_QUEEN_USER:-glucken}
WP_QUEEN_EMAIL=${WP_QUEEN_EMAIL:-glucken@student.42lausanne.ch}
WP_USER_LOGIN=${WP_USER_LOGIN:-glucken_user}
WP_USER_EMAIL=${WP_USER_EMAIL:-glucken+user@student.42lausanne.ch}

mkdir -p "$WORDPRESS_PATH" /var/www/.wp-cli/cache
chown -R www-data:www-data "$WORDPRESS_PATH" /var/www/.wp-cli

export DB_PASSWORD
export DB_NAME
export DB_USER
export DB_HOST
export WP_CLI_CACHE_DIR=/var/www/.wp-cli/cache

until php -r 'mysqli_report(MYSQLI_REPORT_OFF); $db = @new mysqli(getenv("DB_HOST"), getenv("DB_USER"), getenv("DB_PASSWORD"), getenv("DB_NAME")); exit($db->connect_errno ? 1 : 0);'; do
	sleep 2
done

if ! su -s /bin/bash -c "wp core is-installed --path='$WORDPRESS_PATH'" www-data
then
	if [ ! -f "$WORDPRESS_PATH/wp-load.php" ]; then
		su -s /bin/bash -c "wp core download --path='$WORDPRESS_PATH'" www-data
	fi

	if [ ! -f "$WORDPRESS_PATH/wp-config.php" ]; then
		su -s /bin/bash -c "wp core config --path='$WORDPRESS_PATH' --dbname='$DB_NAME' --dbuser='$DB_USER' --dbpass='$DB_PASSWORD' --dbhost='$DB_HOST'" www-data
	fi

	su -s /bin/bash -c "wp core install --path='$WORDPRESS_PATH' --url='$WP_URL' --title='$WP_TITLE' --admin_user='$WP_QUEEN_USER' --admin_password='$wp_queen_password' --admin_email='$WP_QUEEN_EMAIL' --skip-email" www-data

	if ! su -s /bin/bash -c "wp user get '$WP_USER_LOGIN' --path='$WORDPRESS_PATH' >/dev/null 2>&1" www-data
	then
		su -s /bin/bash -c "wp user create '$WP_USER_LOGIN' '$WP_USER_EMAIL' --user_pass='$WP_USER_PASSWORD' --path='$WORDPRESS_PATH'" www-data
	fi
fi


exec /usr/sbin/php-fpm8.2 -F