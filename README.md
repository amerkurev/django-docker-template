# Django + Docker = ❤️
This simple Django project is an excellent template for your future projects. It includes everything you need to quickly set up a quality technology stack and start developing your web application's business logic, skipping all the complex deployment issues at an early stage.

## Technology stack
The technology stack used includes:
- [`Python`](https://www.python.org) ver. 3.11
- [`Django`](https://www.djangoproject.com) ver. 4.2
- [`PostgreSQL`](https://www.postgresql.org) ver. 15
- [`Gunicorn`](https://gunicorn.org) ver. 20.1
- [`Traefik`](https://traefik.io/traefik/) ver. 2.9
- [`Docker`](https://docs.docker.com/get-docker/) and [`Docker Compose`](https://docs.docker.com/compose/)

Nothing extra, only the essentials! You can easily add everything else yourself by expanding the existing configuration files:
- [requirements.txt](https://github.com/amerkurev/django-docker-template/blob/master/requirements.txt)
- [docker-compose.yml](https://github.com/amerkurev/django-docker-template/blob/master/docker-compose.yml)
- and others...

> This project includes a simple Django application from the official Django tutorial - ["a basic poll application"](https://docs.djangoproject.com/en/4.2/intro/tutorial01/). You can safely delete this application at any time. This application is present in the project as an example, used for testing and debugging.

So, what do you get by using this project as a template for your project? Let's take a look.

## Features
- A well-configured Django project, with individual settings that can be changed using environment variables
- Building and debugging a Django project in Docker
- A ready-made docker-compose file that brings together Postgres - Django - Gunicorn - Traefik
- Automatic database migration and static file collection when starting or restarting the Django container
- Automatic creation of the first user in Django with a default login and password
- Automatic creation and renewal of Let's Encrypt certificate 🔥
- Minimal dependencies
- Everything is set up as simply as possible - just a couple of commands in the terminal, and you have a working project 🚀

## How to use


## License

[MIT](LICENSE)
