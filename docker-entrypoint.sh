#!/bin/sh
# vim:sw=4:ts=4:et

set -e

wait-for-it -s database:5432 -t 60
su-exec user python manage.py migrate --noinput
su-exec user python manage.py collectstatic --noinput
su-exec user python manage.py shell -c "from django.contrib.auth.models import User; exit(User.objects.exists())" && \
su-exec user python manage.py createsuperuser --noinput

exec "$@"
