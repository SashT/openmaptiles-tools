#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

echo "+++++++++++++++++++++++++++"
echo "  Create template_postgis"
echo "+++++++++++++++++++++++++++"

# TODO: explain why this is needed
PGUSER="$POSTGRES_USER" psql --dbname="$POSTGRES_DB" <<-'EOSQL'
    CREATE DATABASE template_postgis;
    UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';
EOSQL

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "  Create extensions in template_postgis and $POSTGRES_DB DBs"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

for db in template_postgis "$POSTGRES_DB"; do
echo "Loading extensions into $db"
PGUSER="$POSTGRES_USER" psql --dbname="$db" <<-'EOSQL'
    CREATE EXTENSION postgis;
    CREATE EXTENSION hstore;
    CREATE EXTENSION unaccent;
    CREATE EXTENSION fuzzystrmatch;
    CREATE EXTENSION osml10n;
EOSQL
done
