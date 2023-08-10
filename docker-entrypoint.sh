#!/bin/sh
# vim:sw=4:ts=4:et

set -e

if [ -z ${POSTGRES_DB+x} ]; then
  echo "SQLite will be used.";
else
  wait-for-it -s "$POSTGRES_HOST:$POSTGRES_PORT" -t 60
fi
# You can comment out this line if you want to migrate manually
su-exec "$USER" python manage.py migrate --noinput

exec "$@"
