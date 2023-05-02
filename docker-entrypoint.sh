#!/bin/sh
# vim:sw=4:ts=4:et

set -e

if [ -z ${POSTGRES_DB+x} ]; then
  echo "SQLite will be used.";
else
  wait-for-it -s "$POSTGRES_HOST:$POSTGRES_PORT" -t 60
fi
su-exec "$USER" python manage.py migrate --noinput
su-exec "$USER" python manage.py collectstatic --noinput
su-exec "$USER" python manage.py shell -c "from django.contrib.auth.models import User; exit(User.objects.exists())" && \
su-exec "$USER" python manage.py createsuperuser --noinput

exec "$@"
