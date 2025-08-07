#!/bin/sh
# vim:sw=4:ts=4:et
echo "[*] docker-cmd.sh is running"
echo "[*] Waiting for DB at $POSTGRES_HOST:$POSTGRES_PORT..."

# Wait for Postgres to be ready
echo "Waiting for PostgreSQL at $POSTGRES_HOST:$POSTGRES_PORT..."
/wait-for-db.sh --host=postgres --port=5432 --timeout=60
if [ $? -ne 0 ]; then
    echo "[-] Timeout occurred after waiting 60 seconds for the database"
    exit 1
fi
echo "[+] PostgreSQL is ready."
#su-exec "$USER" python manage.py collectstatic --noinput

# Creating the first user in the system
#USER_EXISTS="from django.contrib.auth import get_user_model; User = get_user_model(); exit(User.objects.exists())"
#su-exec "$USER" python manage.py shell -c "$USER_EXISTS" && su-exec "$USER" python manage.py createsuperuser --noinput

# Run migrations
echo "[*] Running Django migrations..."
python manage.py migrate --noinput

# Create superuser if it doesn't exist
echo "[*] Checking if superuser exists..."
python manage.py shell << EOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='${DJANGO_SUPERUSER_USERNAME:-admin}').exists():
    User.objects.create_superuser(
        username='${DJANGO_SUPERUSER_USERNAME:-admin}',
        email='${DJANGO_SUPERUSER_EMAIL:-admin@example.com}',
        password='${DJANGO_SUPERUSER_PASSWORD:-admin}'
    )
EOF

if [ "$DJANGO_DEBUG" = "true" ]; then
  echo "Starting Django in DEBUG mode with debugpy on port $DJANGO_DEBUG_PORT..."
  exec su-exec "$USER" python -m debugpy \
    --listen 0.0.0.0:$DJANGO_DEBUG_PORT \
    --wait-for-client \
    manage.py runserver 0.0.0.0:$DJANGO_DEV_SERVER_PORT
else
  # Gunicorn
  exec su-exec "$USER" gunicorn "$PROJECT_NAME.wsgi:application" \
    --bind "0.0.0.0:$GUNICORN_PORT" \
    --workers "$GUNICORN_WORKERS" \
    --timeout "$GUNICORN_TIMEOUT" \
    --log-level "$GUNICORN_LOG_LEVEL"
fi


