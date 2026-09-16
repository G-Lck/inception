FROM debian:bookworm-slim

RUN apt-get update
RUN apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/lib/mysql/*
# pourquoi on fait 3 run separes ?

COPY conf/param.cnf /etc/mysql/mariadb.conf.d/param.cnf
COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

VOLUME /var/lib/mysql

ENTRYPOINT ["/usr/local/bin/init.sh"]
