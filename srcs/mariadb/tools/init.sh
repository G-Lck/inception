#!/bin/bash

set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
# pourquoi c'est pas dangerteux de les avoir ici ?
DB_NAME=${DB_NAME:-wordpress}
DB_USER=${DB_USER:-wpuser}

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld


if [ ! -d "/var/lib/mysql/mysql" ];
then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
	mysqld --user=mysql --skip-networking --socket=/tmp/init.sock & PID=$!

    until mysqladmin --socket=/tmp/init.sock ping >/dev/null 2>&1; do
        sleep 1
    done

    mysql --socket=/tmp/init.sock -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
		CREATE DATABASE IF NOT EXISTS \
			\`${DB_NAME}\`;
		DELETE FROM mysql.user WHERE User='';
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL

	mysqladmin -u root -p"${DB_ROOT_PASSWORD}" --socket=/tmp/init.sock shutdown;

	wait $PID;
fi

exec mysqld --user=mysql --bind-address=0.0.0.0