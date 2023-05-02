#!/bin/sh
# vim:sw=4:ts=4:et

su-exec "$USER" gunicorn "$PROJECT_NAME.wsgi:application" \
  --bind "0.0.0.0:$GUNICORN_PORT" \
  --workers "$GUNICORN_WORKERS" \
  --timeout "$GUNICORN_TIMEOUT" \
  --log-level "$GUNICORN_LOG_LEVEL"
