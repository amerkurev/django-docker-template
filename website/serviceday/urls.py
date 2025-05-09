from django.urls import path

from . import views

app_name = "serviceday"
urlpatterns = [
    path("", views.IndexView.as_view(), name="index"),
    path("<int:pk>/", views.DetailView.as_view(), name="detail"),
    path("<int:pk>/stats/", views.ResultsView.as_view(), name="results"),
]
