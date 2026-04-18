arg POSTGRES_VERSION=18

from docker.io/library/postgres:${POSTGRES_VERSION}

arg POSTGRES_VERSION

run apt-get update \
	&& apt-get install -y openssl postgresql-${POSTGRES_VERSION}-pgvector \
    && rm -rf /var/lib/apt/lists/*

copy postgres-ssl.sh /usr/local/bin

run chmod +x /usr/local/bin/postgres-ssl.sh

env PGDATA=/var/lib/postgresql/data
env PG_SSL_DIR=/var/lib/postgresql/ssl

entrypoint ["/usr/local/bin/postgres-ssl.sh"]
