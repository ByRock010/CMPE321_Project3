from django.urls import path
from . import views

urlpatterns = [
    path('', views.match_list, name='home'),  # show match list at root
    path('matches/', views.match_list, name='match_list'),
    path('matches/<int:match_id>/', views.match_detail, name='match_detail'),
    path('create_match/', views.create_match, name='create_match'),
    path('assign_black/<int:match_id>/', views.assign_black_player, name='assign_black'),

]
