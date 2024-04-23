# Django + Docker = ❤️
<div markdown="1">

[![Build](https://github.com/amerkurev/django-docker-template/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/amerkurev/django-docker-template/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/amerkurev/django-docker-template/badge.svg)](https://coveralls.io/github/amerkurev/django-docker-template)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/amerkurev/django-docker-template/blob/master/LICENSE)
</div>

This simple Django project is an excellent template for your future projects. 
It includes everything you need to quickly set up a quality technology stack and start developing your web application's business logic, skipping all the complex deployment issues at an early stage.

## See in Action
Deploying a Django Project in Production with Automatic Let's Encrypt HTTPS in Just 55 Seconds... 🏎️💨 ...🏁

<a href="https://asciinema.org/a/632218" ><img width="939" alt="image" src="https://github.com/amerkurev/django-docker-template/assets/28217522/6409c517-e868-4baf-8be6-18bb0d59e5f7"></a>

*[Star this project if it's what you were looking for!](https://github.com/amerkurev/django-docker-template) ⭐️*

## Technology stack
The technology stack used includes:

- [`Python`](https://www.python.org) ver. 3.11
- [`Django`](https://www.djangoproject.com) ver. 4.2
- [`PostgreSQL`](https://www.postgresql.org) ver. 15
- [`Gunicorn`](https://gunicorn.org) ver. 21.2
- [`Traefik`](https://traefik.io/traefik/) ver. 2.9
- [`Caddy`](https://caddyserver.com) ver. 2.7 *(instead of Traefik if you wish)*
- [`Docker`](https://docs.docker.com/get-docker/) and [`Docker Compose`](https://docs.docker.com/compose/)

Nothing extra, only the essentials! You can easily add everything else yourself by expanding the existing configuration files:

- [requirements.txt](https://github.com/amerkurev/django-docker-template/blob/master/requirements.txt)
- [docker-compose.yml](https://github.com/amerkurev/django-docker-template/blob/master/docker-compose.yml)
- [pytest.ini](https://github.com/amerkurev/django-docker-template/blob/master/website/pytest.ini)
- and others...

> This project includes a simple Django application from the official Django tutorial - ["a basic poll application"](https://docs.djangoproject.com/en/4.2/intro/tutorial01/).
> You can safely delete this application at any time. This application is present in the project as an example, used for testing and debugging.

So, what do you get by using this project as a template for your project? Let's take a look.

## Features
- A well-configured Django project, with individual settings that can be changed using environment variables
- Building and debugging a Django project in Docker
- Integrated [pytest](https://docs.pytest.org) and [coverage](https://coverage.readthedocs.io) for robust testing and code quality assurance ✅
- A ready-made docker-compose file that brings together Postgres - Django - Gunicorn - Traefik (or Caddy)
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

Now you can go to [http://127.0.0.1:8000/admin/](http://127.0.0.1:8000/admin/) in your browser. Go to the Django admin panel and try updating the server code "on the fly".
Everything works just like if you were running the Django development server outside the container.

> Note that we mount the directory with your source code inside the container, so you can work with the project in your IDE, and changes will be visible inside the container, and the Django development server will restart itself. 

<details markdown="1">
<summary>SQLite Usage Details</summary>

> Another important point is the use of SQLite3 instead of Postgres, because Postgres is not deployed until Django is run within a Docker Compose environment.
> In our example, we add a volume named `sqlite`. This data is stored persistently and does not disappear between restarts of the Django development server.
> However, if you have a second similar project, it would be better to change the volume name from `sqlite` to something else so that the second project uses its own copy of the database. For example:
>
```console
docker run -it --rm -p 8000:8000 -v another_sqlite:/sqlite -v $(pwd)/website:/usr/src/website django-docker-template:master python manage.py runserver 0.0.0.0:8000
```
> 
>  To better understand how volumes work in Docker, refer to the official [documentation](https://docs.docker.com/storage/volumes/).
</details>

5. Run tests with pytest and coverage ✅:
```console
docker run --rm django-docker-template:master ./pytest.sh
```
The [pytest.sh](https://github.com/amerkurev/django-docker-template/blob/master/website/pytest.sh) script runs tests using pytest and coverage. As a result, you will see an output like this in the terminal:
```console
================== test session starts =====================================
platform linux -- Python 3.11.7, pytest-7.4.4, pluggy-1.3.0
django: version: 4.2.9, settings: website.settings (from ini)
rootdir: /usr/src/website
configfile: pytest.ini
plugins: django-4.7.0
collected 10 items

polls/tests.py .......... [100%]

================== 10 passed in 0.19s ======================================
Name                                       Stmts   Miss  Cover   Missing
------------------------------------------------------------------------
polls/__init__.py                              0      0   100%
polls/admin.py                                12      0   100%
polls/apps.py                                  4      0   100%
polls/migrations/0001_initial.py               6      0   100%
polls/migrations/0002_question_upload.py       4      0   100%
polls/migrations/__init__.py                   0      0   100%
polls/models.py                               20      2    90%   15, 33
polls/tests.py                                57      0   100%
polls/urls.py                                  4      0   100%
polls/views.py                                28      8    71%   39-58
website/__init__.py                            6      0   100%
website/settings.py                           52      2    96%   94, 197
website/urls.py                                6      0   100%
------------------------------------------------------------------------
TOTAL                                        199     12    94%
```

> If you don't want to use pytest (for some reason), you can run the tests without pytest using the command below:
```console
docker run --rm django-docker-template:master python manage.py test
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
And after a few seconds, open your browser at [http://127.0.0.1/admin/](http://127.0.0.1/admin/). The superuser with the login and password `admin/admin` is already created, welcome to the Django admin panel.

Django is still in Debug mode! You can work in your IDE, write code, and immediately see changes inside the container. However, you are currently using Traefik and Postgres.
You can also add Redis or MongoDB, and all of this will work in your development environment. This is very convenient.

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

Some Django settings from the [`settings.py`](https://github.com/amerkurev/django-docker-template/blob/master/website/website/settings.py) file are stored in environment variables.
You can easily change these settings in the [`.env`](https://github.com/amerkurev/django-docker-template/blob/master/.env) file.
This file does not contain all the necessary settings, but many of them. Add additional settings to environment variables if needed.

> It is important to note the following: **never store sensitive settings such as DJANGO_SECRET_KEY or DJANGO_EMAIL_HOST_PASSWORD in your repository!**
> Docker allows you to override environment variable values from additional files, the command line, or the current session. Store passwords and other sensitive information separately from the code and only connect this information at system startup.

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

### Using Caddy Server Instead of Traefik

Traefik is a great edge router, but it doesn't serve static files, which is why we pair it with [Nginx](https://github.com/amerkurev/django-docker-template/blob/master/docker-compose.yml#L26) in our setup.
If you prefer a single tool that can handle everything, you might want to try [Caddy](https://caddyserver.com).

Caddy can automatically handle the creation and renewal of Let's Encrypt certificates and also serve static files, which allows you to use just one server instead of two.

Here's how to set up Caddy with your project:

1. Ensure you have a [`Caddyfile`](https://github.com/amerkurev/django-docker-template/blob/master/Caddyfile) in your project directory. This file will tell Caddy how to deliver static and media files and how to forward other requests to your Django app.

2. Swap out the `docker-compose.yml` and `docker-compose.tls.yml` with a single [`docker-compose.caddy.yml`](https://github.com/amerkurev/django-docker-template/blob/master/docker-compose.caddy.yml). This file is designed to set up Caddy with Django and Postgres, and it doesn't include Nginx, which makes the file shorter and easier to understand.

3. To get your Django project up with Caddy, run the following command, making sure to replace `your.domain.com` with your actual domain:

```console
MY_DOMAIN=your.domain.com docker compose -f docker-compose.caddy.yml up -d
```

Choosing Caddy simplifies your setup by combining the functionalities of Traefik and Nginx into one. It's straightforward and takes care of HTTPS certificates for you automatically.
Enjoy the ease of deployment with Caddy!

## What's next?

Now that you have a working project, you can extend it as you like, adding [dashboards for monitoring service health](https://doc.traefik.io/traefik/operations/dashboard/), [centralized log collection](https://www.fluentd.org), [secret storage](https://www.vaultproject.io), and of course, your own Django applications.
All of this is beyond the scope of the current description, as the idea of this project is minimalism and providing only the essentials. Good luck!

## License

[MIT](https://github.com/amerkurev/django-docker-template/blob/master/LICENSE)
