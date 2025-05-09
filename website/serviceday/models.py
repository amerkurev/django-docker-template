from django.db import models

class ServiceDay(models.Model):
    SERVICE_TYPE_CHOICES = [
        (1, 'Weekday'),
        (2, 'Saturday'),
        (3, 'Sunday'),
        (4, 'Holiday'),
    ]

    servicedate = models.DateField(unique=True, help_text="The calendar date for this service day.")
    servicetype = models.IntegerField(
        choices=SERVICE_TYPE_CHOICES, 
        default=1, 
        help_text="Type of transit service in play for the day."
    )
    actual_miles = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=0.0, 
        help_text="Total actual miles for the day."
    )
    revenue_miles = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=0.0, 
        help_text="Total revenue miles for the day."
    )
    actual_hours = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=0.0, 
        help_text="Total actual hours for the day."
    )
    revenue_hours = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=0.0, 
        help_text="Total revenue hours for the day."
    )
    number_of_buses = models.PositiveIntegerField(
        default=0, 
        help_text="Number of buses in operation for the day."
    )
    scheduled_trips = models.PositiveIntegerField(
        default=0, 
        help_text="Total number of scheduled trips for the day."
    )
    missed_trips = models.PositiveIntegerField(
        default=0, 
        help_text="Total number of missed trips for the day."
    )
    canceled_trips = models.PositiveIntegerField(
        default=0, 
        help_text="Total number of canceled trips for the day."
    )

    def __str__(self):
        return f"ServiceDay: {self.servicedate} (Type: {dict(self.SERVICE_TYPE_CHOICES).get(self.servicetype)})"

    class Meta:
        ordering = ['servicedate']
        verbose_name = "Service Day"
        verbose_name_plural = "Service Days"
