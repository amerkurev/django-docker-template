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
- Serving static files (and user-uploaded files) with Nginx
- Automatic database migration and static file collection when starting or restarting the Django container
- Automatic creation of the first user in Django with a default login and password
- Automatic creation and renewal of Let's Encrypt certificate 🔥
- Minimal dependencies
- Everything is set up as simply as possible - just a couple of commands in the terminal, and you have a working project 🚀

## How to use

### For development on your computer

1. Clone the repository to your computer and go to the `django-docker-template` directory:
```console
git clone https://github.com/amerkurev/django-docker-template.git
cd django-docker-template
```

2. Build the Docker container image with Django:
```console
docker build -t django-docker-template:master .
```

3. Create the first superuser:
```console
docker run -it --rm -v sqlite:/sqlite django-docker-template:master python manage.py createsuperuser
```

4. Run the Django development server inside the Django container:
```console
docker run -it --rm -p 8000:8000 -v sqlite:/sqlite -v $(pwd)/website:/usr/src/website django-docker-template:master python manage.py runserver 0.0.0.0:8000
```

Now you can go to http://127.0.0.1:8000/admin/ in your browser. Go to the Django admin panel and try updating the server code "on the fly." Everything works just like if you were running the Django development server outside the container.

> Note that we mount the directory with your source code inside the container, so you can work with the project in your IDE, and changes will be visible inside the container, and the Django development server will restart itself. 
>
> Another important point is the use of SQLite3 instead of Postgres (which we don't run). In our example, we add a volume named `sqlite`. This data is stored persistently and does not disappear between restarts of the Django development server. However, if you have a second similar project, it would be better to change the volume name from `sqlite` to something else so that the second project uses its own copy of the database. For example:
>
>```console
>docker run -it --rm -p 8000:8000 -v another_sqlite:/sqlite -v $(pwd)/website:/usr/src/website django-docker-template:master python manage.py runserver 0.0.0.0:8000
>```
>
> To better understand how volumes work in Docker, refer to the official [documentation](https://docs.docker.com/storage/volumes/).

5. Run tests:
```console
docker run -it --rm django-docker-template:master python manage.py test polls
```

6. Interactive shell with the Django project environment:
```console
docker run -it --rm -v sqlite:/sqlite django-docker-template:master python manage.py shell
```

7. Start all services locally (Postgres, Gunicorn, Traefik) using docker-compose:
```console
docker compose -f docker-compose.debug.yml up
```

Enjoy watching the lines run in the terminal 🖥️   
And after a few seconds, open your browser at http://127.0.0.1/admin/. The superuser with the login and password `admin/admin` is already created, welcome to the Django admin panel.

Django is still in Debug mode! You can work in your IDE, write code, and immediately see changes inside the container. However, you are currently using Traefik and Postgres. You can also add Redis or MongoDB, and all of this will work in your development environment. This is very convenient.

> Between Docker Compose restarts, your database data and media files uploaded to the server will be preserved because they are stored in special volumes that are not deleted when containers are restarted.

Want to delete everything? No problem, the command below will stop all containers, remove them and their images.
```console
docker compose down --remove-orphans --rmi local
```

To delete the Postgre database as well, add the `-v` flag to the command:
```console
docker compose down --remove-orphans --rmi local -v
```

#### Django settings

Some Django settings from the [`settings.py`](https://github.com/amerkurev/django-docker-template/blob/master/website/website/settings.py) file are stored in environment variables. You can easily change these settings in the [`.env`](https://github.com/amerkurev/django-docker-template/blob/master/.env) file. This file does not contain all the necessary settings, but many of them. Add additional settings to environment variables if needed. 

> It is important to note the following: **never store sensitive settings such as DJANGO_SECRET_KEY or DJANGO_EMAIL_HOST_PASSWORD in your repository!** Docker allows you to override environment variable values from additional files, the command line, or the current session. Store passwords and other sensitive information separately from the code and only connect this information at system startup.

### For deployment on a server

#### Prerequisite

For the Let's Encrypt HTTP challenge you will need:
- A publicly accessible host allowing connections on port `80` & `443` with docker & docker-compose installed. A virtual machine in any cloud provider can be used as a host.
- A DNS record with the domain you want to expose pointing to this host.

#### Steps on a server

1. Clone the repository on your host and go to the `django-docker-template` directory:
```console
git clone https://github.com/amerkurev/django-docker-template.git
cd django-docker-template
```

2. Configure as described in the [Django settings](#django-settings) section or leave everything as is.

3. Run, specifying your domain:
```console
MY_DOMAIN=your.domain.com docker compose -f docker-compose.yml -f docker-compose.tls.yml up -d
```

It will take a few seconds to start the database, migrate, collect static files, and obtain a Let's Encrypt certificate. So wait a little and open https://your.domain.com in your browser. Your server is ready to work 🏆 

> Don't worry about renewing the Let's Encrypt certificate, it will happen automatically.

4. After running the containers, you can execute [manage.py commands](https://docs.djangoproject.com/en/4.2/ref/django-admin/#available-commands) using this format:
```console
docker compose exec django python manage.py check --deploy

docker compose exec django python manage.py shell
```

## What's next?

Now that you have a working project, you can extend it as you like, adding [dashboards for monitoring service health](https://doc.traefik.io/traefik/operations/dashboard/), [centralized log collection](https://www.fluentd.org), [secret storage](https://www.vaultproject.io), and of course, your own Django applications. All of this is beyond the scope of the current description, as the idea of this project is minimalism and providing only the essentials. Good luck!

## License

[MIT](LICENSE)
