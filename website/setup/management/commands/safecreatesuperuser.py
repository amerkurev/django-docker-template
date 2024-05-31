"""
This custom management command creates a superuser if it doesn't exist.
Does not have interactive handling like createsuperuser.
"""

import os

from django.contrib.auth import get_user_model
from django.core.management.base import BaseCommand


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

        obj, created = User.objects.get_or_create(
            username=options["username"],
            email=options["email"],
            password=options["password"],
            is_superuser=True,
            is_staff=True,
        )

        if created:
            self.stdout.write(self.style.SUCCESS("Admin user created"))
        else:
            self.stdout.write(self.style.SUCCESS("Admin user already exists"))
