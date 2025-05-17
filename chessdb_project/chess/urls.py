from django.urls import path
from . import views

urlpatterns = [
    path('', views.homepage, name='home'),
    path('matches/', views.match_list, name='match_list'),
    path('matches/<int:match_id>/', views.match_detail, name='match_detail'),
    path('create_match/', views.create_match, name='create_match'),
    path('assign_black/<int:match_id>/', views.assign_black_player, name='assign_black'),
    path('players/', views.players_home, name='players_home'),
    path('coaches/', views.coaches_home, name='coaches_home'),
    path('arbiters/', views.arbiters_home, name='arbiters_home'),
    path('dbmanagers/', views.dbmanagers_home, name='dbmanagers_home'),
    path('players/match_history/', views.view_match_history, name='view_match_history'),
    path('players/stats/', views.view_player_stats, name='view_player_stats'),
    path('coaches/delete_match/', views.delete_match, name='delete_match'),
    path('coaches/available_halls/', views.view_available_halls, name='view_available_halls'),
    path('arbiters/assigned_matches/', views.view_assigned_matches, name='view_assigned_matches'),
    path('arbiters/submit_rating/', views.submit_rating, name='submit_rating'),
    path('arbiters/rating_stats/', views.view_rating_stats, name='view_rating_stats'),
    path('dbmanagers/add_player/', views.add_player, name='add_player'),
    path('dbmanagers/add_coach/', views.add_coach, name='add_coach'),
    path('dbmanagers/add_arbiter/', views.add_arbiter, name='add_arbiter'),
    path('dbmanagers/rename_hall/', views.rename_hall, name='rename_hall'),


]
