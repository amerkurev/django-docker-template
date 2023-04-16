FROM python:3.11-alpine as base

FROM base as builder

RUN apk update && apk --no-cache add python3-dev libpq-dev && mkdir /install
WORKDIR /install
COPY requirements.txt ./
RUN pip install --no-cache-dir --prefix=/install -r ./requirements.txt

FROM base

ARG USER=user
ARG USER_UID=1001
ARG PROJECT_NAME=website
ARG DJANGO_BASE_DIR=/usr/src/$PROJECT_NAME
ARG DJANGO_STATIC_ROOT=/var/$PROJECT_NAME/static
ARG DJANGO_SQLITE_DIR=/sqlite
ARG GUNICORN_PORT=8000

ENV \
	USER=$USER \
	USER_UID=$USER_UID \
	PROJECT_NAME=$PROJECT_NAME \
	DJANGO_BASE_DIR=$DJANGO_BASE_DIR \
	DJANGO_STATIC_ROOT=$DJANGO_STATIC_ROOT \
	DJANGO_SQLITE_DIR=$DJANGO_SQLITE_DIR \
	GUNICORN_PORT=$GUNICORN_PORT


COPY --from=builder /install /usr/local
COPY docker-entrypoint.sh /
COPY run-server.sh /
COPY $PROJECT_NAME $DJANGO_BASE_DIR

# User
RUN chmod +x /docker-entrypoint.sh /run-server.sh && \
    apk --no-cache add su-exec libpq-dev && \
    mkdir -p $DJANGO_STATIC_ROOT $DJANGO_SQLITE_DIR && \
    adduser -s /bin/sh -D -u $USER_UID $USER && \
    chown -R $USER:$USER $DJANGO_BASE_DIR $DJANGO_STATIC_ROOT $DJANGO_SQLITE_DIR

ENTRYPOINT ["/docker-entrypoint.sh"]
WORKDIR $DJANGO_BASE_DIR
EXPOSE $GUNICORN_PORT

CMD ["/run-server.sh", "sh", "-c", "su-exec user gunicorn ${PROJECT_NAME}.wsgi:application --bind 0.0.0.0:${GUNICORN_PORT}"]
