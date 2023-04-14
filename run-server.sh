#!/bin/sh
# vim:sw=4:ts=4:et

set -e

wait-for-it -s database:5432 -t 60
su-exec "$USER" python manage.py migrate --noinput
su-exec "$USER" python manage.py collectstatic --noinput
su-exec "$USER" python manage.py shell -c "from django.contrib.auth.models import User; exit(User.objects.exists())" && \
su-exec "$USER" python manage.py createsuperuser --noinput

exec "$@"
