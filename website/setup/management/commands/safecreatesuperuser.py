"""
This custom management command creates a superuser if it doesn't exist.
Does not have interactive handling like createsuperuser.
"""

import os

from django.contrib.auth import get_user_model
from django.core.management.base import BaseCommand
from django.contrib.auth.hashers import make_password


class Command(BaseCommand):
    help = "Safely create an admin user if it doesn't exist"

    def add_arguments(self, parser):
        parser.add_argument("--username", help="Username for superuser")
        parser.add_argument("--email", help="Email for superuser")
        parser.add_argument("--password", help="Password for superuser")
        parser.add_argument(
            "--no-input",
            "--noinput",
            help="Use preset options from within the environment",
            action="store_true",
        )

    def handle(self, *args, **options):
        User = get_user_model()

        if options["no_input"]:
            options["username"] = os.environ["DJANGO_SUPERUSER_USERNAME"]
            options["email"] = os.environ["DJANGO_SUPERUSER_EMAIL"]
            options["password"] = os.environ["DJANGO_SUPERUSER_PASSWORD"]

        defaults = {
            "email": options["email"],
            "password": make_password(options["password"]),
            "is_superuser": True,
            "is_staff": True,
        }

        obj, created = User.objects.get_or_create(
            username=options["username"],
            defaults=defaults,
        )

        if created:
            self.stdout.write(self.style.SUCCESS(f"Superuser created: {obj}"))
        else:
            self.stdout.write(self.style.SUCCESS(f"Superuser already exists: {obj}"))
