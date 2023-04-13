#!/bin/sh
# vim:sw=4:ts=4:et

set -e

su-exec user python manage.py migrate --noinput
su-exec user python manage.py collectstatic --noinput

exec "$@"
