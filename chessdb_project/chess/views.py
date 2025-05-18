from django import forms
from django.contrib import messages
from django.db import connection
from django.http import Http404
from django.shortcuts import redirect, render
import hashlib


class AssignBlackForm(forms.Form):    # ilk kez form kullandım la bilmiyodum böyle bi şey oldğunu
    black_player = forms.CharField(max_length=50)
    black_team_id = forms.IntegerField()




def match_list(request):
    with connection.cursor() as cur:
        cur.execute("""
            SELECT match_id, white_player, black_player, match_date, time_slot
            FROM ChessMatch
            ORDER BY match_date, time_slot
        """)
        matches = [dict(zip([col[0] for col in cur.description], row)) for row in cur.fetchall()]
    return render(request, 'chess/match_list.html', {'matches': matches})

def match_detail(request, match_id):
    with connection.cursor() as cur:
        cur.execute("SELECT * FROM ChessMatch WHERE match_id = %s", [match_id])
        row = cur.fetchone()
        if not row:
            raise Http404("Match not found")
        match = dict(zip([col[0] for col in cur.description], row))
    return render(request, 'chess/match_detail.html', {'match': match})

from django import forms
from django.contrib import messages
from django.shortcuts import redirect


class MatchCreateForm(forms.Form):
    white_player = forms.CharField(max_length=50)
    white_team_id = forms.IntegerField()
    black_team_id = forms.IntegerField()
    match_date = forms.DateField(widget=forms.DateInput(attrs={'type': 'date'}))
    time_slot = forms.IntegerField(min_value=1, max_value=4)
    hall_id = forms.IntegerField()
    table_id = forms.IntegerField()
    arbiter_username = forms.CharField(max_length=50)
    creator = forms.CharField(max_length=50)  # will be the coach's username

def create_match(request):
    if request.method == 'POST':
        form = MatchCreateForm(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            # data['creator'] = request.user.username  # use the logged-in coach
            try:
                with connection.cursor() as cur:
                    cur.callproc("create_match", [
                        data['white_player'],
                        data['white_team_id'],
                        data['black_team_id'],
                        data['match_date'],
                        data['time_slot'],
                        data['hall_id'],
                        data['table_id'],
                        data['arbiter_username'],
                        data['creator']
                    ])
                messages.success(request, "Match created successfully!")
                return redirect('match_list')
            except Exception as e:
                messages.error(request, f"Error: {str(e)}")
    else:
        form = MatchCreateForm()

    return render(request, 'chess/create_match.html', {'form': form})



def assign_black_player(request, match_id):
    if request.method == 'POST':
        form = AssignBlackForm(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            try:
                with connection.cursor() as cur:
                    cur.callproc("assign_black_player", [
                        match_id,
                        data['black_player'],
                        data['black_team_id']
                    ])
                messages.success(request, "Black player assigned successfully!")
                return redirect('match_detail', match_id=match_id)
            except Exception as e:
                messages.error(request, f"Error: {str(e)}")
    else:
        form = AssignBlackForm()

    return render(request, 'chess/assign_black.html', {
        'form': form,
        'match_id': match_id
    })


def homepage(request):
    return render(request, 'chess/home.html')

def login(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")

        password = request.POST.get("password")
        hashed_password = hashlib.sha256(password.encode()).hexdigest()


        with connection.cursor() as cursor:
            cursor.callproc('AuthenticateUser', [username, hashed_password, None])

        
            cursor.execute('SELECT @_AuthenticateUser_2')  
            result = cursor.fetchone()

        if result and result[0]:
            role = result[0]
            request.session['username'] = username
            request.session['role'] = role

            if role == "Player":
                return redirect("players_home")
            elif role == "Coach":
                return redirect("coaches_home")
            elif role == "Arbiter":
                return redirect("arbiters_home")
            elif role == "Admin":
                return redirect("dbmanagers_home")
        else:
            messages.error(request, "Invalid credentials")

    return render(request, 'chess/login.html')

def players_home(request):
    return render(request, 'chess/players_home.html')

def coaches_home(request):
    return render(request, 'chess/coaches_home.html')

def arbiters_home(request):
    return render(request, 'chess/arbiters_home.html')

def dbmanagers_home(request):
    return render(request, 'chess/dbmanagers_home.html')

def view_match_history(request):
    return render(request, 'chess/placeholder.html', {'message': 'Match history coming soon'})

def view_player_stats(request):
    return render(request, 'chess/placeholder.html', {'message': 'Statistics will be shown here'})

def delete_match(request):
    return render(request, 'chess/placeholder.html', {'message': 'Match deletion coming soon'})

def view_available_halls(request):
    return render(request, 'chess/placeholder.html', {'message': 'Available halls will be listed here'})

def view_assigned_matches(request):
    return render(request, 'chess/placeholder.html', {'message': 'Assigned matches will be shown here'})

def submit_rating(request):
    return render(request, 'chess/placeholder.html', {'message': 'Rating submission form coming soon'})

def view_rating_stats(request):
    return render(request, 'chess/placeholder.html', {'message': 'Your average ratings and match count will be here'})

def add_player(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        name = request.POST.get('name')
        surname = request.POST.get('surname')
        nationality = request.POST.get('nationality')
        date_of_birth = request.POST.get('date_of_birth')
        elo = request.POST.get('elo_rating')
        fide_id = request.POST.get('fide_id')
        title= request.POST.get('title_id')

        with connection.cursor() as cursor:
            # Check if user exists
            cursor.execute("SELECT 1 FROM User WHERE username = %s", [username])
            if cursor.fetchone():
                messages.error(request, f"Username '{username}' already exists.")
                return render(request, 'chess/addplayer.html')

            try:
                cursor.callproc('AddUser', [username, password, name, surname, nationality])
                cursor.callproc('AddPlayer', [username, date_of_birth, elo, fide_id, title])
                messages.success(request, "Player added successfully!")
                return redirect('dbmanagers_home')
            except Exception as e:
                messages.error(request, f"ERROR: {str(e)}")

    return render(request, 'chess/addplayer.html')


def add_coach(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        name = request.POST.get('name')
        surname = request.POST.get('surname')
        nationality = request.POST.get('nationality')
        team_id = request.POST.get('team_id')
        contract_start = request.POST.get('contract_start')
        contract_finish = request.POST.get('contract_finish')

        with connection.cursor() as cursor:
            # Check duplicate
            cursor.execute("SELECT 1 FROM User WHERE username = %s", [username])
            if cursor.fetchone():
                messages.error(request, f"Username '{username}' already exists.")
                return render(request, 'chess/addcoach.html')

            try:
                # 1. Insert into User (trigger hashes password)
                cursor.callproc('AddUser', [username, password, name, surname, nationality])
                
                # 2. Insert into Coach
                cursor.execute("INSERT INTO Coach (username) VALUES (%s)", [username])

                # 3. Insert into Coach_Team_Agreement
                cursor.execute("""
                    INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
                    VALUES (%s, %s, STR_TO_DATE(%s, '%%d-%%m-%%Y'), STR_TO_DATE(%s, '%%d-%%m-%%Y'))
                """, [username, team_id, contract_start, contract_finish])

                messages.success(request, "Coach created successfully!")
                return redirect('dbmanagers_home')
            except Exception as e:
                messages.error(request, f"ERROR: {str(e)}")

    return render(request, 'chess/addcoach.html')


def add_arbiter(request):
    return render(request, 'chess/placeholder.html', {'message': 'Arbiter creation form coming soon'})

def rename_hall(request):
    return render(request, 'chess/placeholder.html', {'message': 'Hall rename operation coming soon'})
