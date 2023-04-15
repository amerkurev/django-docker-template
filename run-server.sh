#!/bin/sh
# vim:sw=4:ts=4:et

set -e

su-exec "$USER" python manage.py shell -c "from django.contrib.auth.models import User; exit(User.objects.exists())" && \
su-exec "$USER" python manage.py createsuperuser --noinput

exec "$@"
