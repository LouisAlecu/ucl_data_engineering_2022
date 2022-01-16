FROM postgres:12.1

COPY schema_init.sql /docker-entrypoint-initdb.d/
COPY postgres_conf.cfg /docker-entrypoint-initdb.d/
COPY update_config.sh /docker-entrypoint-initdb.d/

EXPOSE 5432
