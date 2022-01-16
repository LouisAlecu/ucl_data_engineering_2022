#/bin/bash

cat /docker-entrypoint-initdb.d/postgres_conf.cfg >> /var/lib/postgresql/data/pg_hba.conf
