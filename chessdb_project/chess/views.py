import hashlib

from django import forms
from django.contrib import messages
from django.db import connection
from django.http import Http404
from django.shortcuts import redirect, render


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
    # creator = forms.CharField(max_length=50)  # will be the coach's username

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
                        # data['creator'],
                        request.session.get('username')
                    ])
                messages.success(request, "Match created successfully!")
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

import hashlib

def login(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        hashed_password = hashlib.sha256(password.encode()).hexdigest() ##BUNU COMMENTLERSİN BABA SENDE ÇALIŞSIN


    

        with connection.cursor() as cursor:
            cursor.callproc('AuthenticateUser', [username, password, None])
            cursor.callproc('AuthenticateUser', [username, hashed_password, None]) ## BUNU DA COMMENTLERSİN BABA

        
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

def view_played_opponents(request):
    username = request.session.get("username")
    if not username:
        messages.error(request, "You must be logged in.")
        return redirect('login')

    try:
        with connection.cursor() as cursor:
            cursor.callproc("GetPlayerOpponents", [username])
            opponents = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]
    except Exception as e:
        messages.error(request, f"Failed to load opponents: {str(e)}")
        opponents = []

    return render(request, 'chess/view_opponents.html', {
        'username': username,
        'opponents': opponents
    })


def view_player_stats(request):
    username = request.session.get("username")
    if not username:
        messages.error(request, "You must be logged in.")
        return redirect('login')

    try:
        with connection.cursor() as cursor:
            cursor.callproc("GetPlayerOpponentsWithELO", [username])
            result = cursor.fetchone()

            if result:
                most_played_opponent = result[0]
                reported_elo = result[1]
            else:
                most_played_opponent = "No opponents found"
                reported_elo = "N/A"

    except Exception as e:
        messages.error(request, f"Error retrieving stats: {str(e)}")
        most_played_opponent = "Error"
        reported_elo = "Error"

    return render(request, 'chess/player_stats.html', {
        'username': username,
        'most_played_opponent': most_played_opponent,
        'reported_elo': reported_elo
    })



def delete_match(request):
    if request.method == "POST":
        match_id = request.POST.get("match_id")
        coach_username = request.session.get("username")

        if not coach_username:
            messages.error(request, "You must be logged in as a coach to delete a match.")
            return redirect("login")

        try:
            match_id = int(match_id)
        except (TypeError, ValueError):
            messages.error(request, "Invalid match ID.")
            return render(request, 'chess/delete_match.html')

        try:
            with connection.cursor() as cursor:
                # Check if this coach created the match
                cursor.execute("""
                    SELECT COUNT(*) FROM ChessMatch
                    WHERE match_id = %s AND created_by = %s
                """, [match_id, coach_username])
                count = cursor.fetchone()[0]

                if count == 0:
                    messages.error(request, "You can only delete matches you created.")
                else:
                    cursor.execute("DELETE FROM ChessMatch WHERE match_id = %s", [match_id])
                    messages.success(request, "Match deleted successfully!")

        except Exception as e:
            messages.error(request, f"Deletion failed: {str(e)}")

    return render(request, 'chess/delete_match.html')


def view_available_halls(request):
    if request.session.get("role") != "Coach":
        messages.error(request, "Only coaches can view available halls.")
        return redirect("login")

    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT hall_id, hall_name, hall_country FROM Hall ORDER BY hall_id")
            halls = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]
    except Exception as e:
        messages.error(request, f"Failed to load halls: {str(e)}")
        halls = []

    return render(request, 'chess/available_halls.html', {'halls': halls})


def view_assigned_matches(request):
    username = request.session.get("username")
    role = request.session.get("role")

    if not username or role != "Arbiter":
        messages.error(request, "You must be logged in as an arbiter.")
        return redirect('login')

    try:
        with connection.cursor() as cursor:
            cursor.callproc('GetAssignedMatches', [username])
            rows = cursor.fetchall()
            assigned_matches = [dict(zip([col[0] for col in cursor.description], row)) for row in rows]

    except Exception as e:
        messages.error(request, f"Failed to retrieve matches: {str(e)}")
        assigned_matches = []

    return render(request, 'chess/assigned_matches.html', {'matches': assigned_matches})


from django.db import transaction


def submit_rating(request):
    username = request.session.get("username")
    role = request.session.get("role")

    if not username or role != "Arbiter":
        messages.error(request, "You must be logged in as an arbiter.")
        return redirect('login')

    if request.method == "POST":
        match_id = request.POST.get("match_id")
        rating = request.POST.get("rating")

        try:
            match_id = int(match_id)
            rating = int(rating)
            if rating < 1 or rating > 10:
                raise ValueError("Rating must be between 1 and 10")

            print("Calling stored procedure SubmitRating with:", match_id, rating, username)

            with connection.cursor() as cursor:
                cursor.callproc("SubmitRating", [match_id, rating, username])

            messages.success(request, "Rating submitted successfully!")
            return redirect("view_assigned_matches")

        except Exception as e:
            print("Exception during rating:", str(e))  # ADD THIS
            messages.error(request, f"Submission failed: {str(e)}")

    return render(request, 'chess/submit_rating.html')



def view_rating_stats(request):
    username = request.session.get("username")
    role = request.session.get("role")

    if not username or role != "Arbiter":
        messages.error(request, "You must be logged in as an arbiter.")
        return redirect("login")

    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT 
                    COUNT(rating) AS match_count,
                    ROUND(AVG(rating), 2) AS avg_rating
                FROM ChessMatch
                WHERE rating IS NOT NULL
                  AND assigned_arbiter_username = %s
            """, [username])
            result = cursor.fetchone()
            match_count = result[0] or 0
            avg_rating = result[1] or 0.0

    except Exception as e:
        messages.error(request, f"Failed to load rating stats: {str(e)}")
        match_count = 0
        avg_rating = 0.0

    return render(request, 'chess/rating_stats.html', {
        'username': username,
        'match_count': match_count,
        'avg_rating': avg_rating,
    })


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
        title = request.POST.get('title_id')

        with connection.cursor() as cursor:
            cursor.callproc('AddUser', [username, password, name, surname, nationality, 'Player'])
            cursor.callproc('AddPlayer', [username, date_of_birth, elo, fide_id, title])
            result = cursor.fetchone()
            if not result:
                messages.error(request, "ERROR")
                    
                    
    return render(request, 'chess/addplayer.html')



def add_coach(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        name = request.POST.get('name')
        surname = request.POST.get('surname')
        nationality = request.POST.get('nationality')
        
        with connection.cursor() as cursor:
            cursor.callproc('AddUser', [username, password, name, surname, nationality, 'Coach'])
            cursor.callproc('AddCoach', [username])
            result = cursor.fetchone()
            if not result:
                messages.error(request, "ERROR")
                    
    return render(request, 'chess/addcoach.html')

def add_arbiter(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        name = request.POST.get('name')
        surname = request.POST.get('surname')
        nationality = request.POST.get('nationality')
        experience = request.POST.get('experience')
        
        with connection.cursor() as cursor:
            cursor.callproc('AddUser', [username, password, name, surname, nationality, 'Arbiter'])
            cursor.callproc('AddArbiter', [username, experience])
            result = cursor.fetchone()
            if not result:
                messages.error(request, "ERROR")
    return render(request, 'chess/addarbiter.html')

def rename_hall(request):
    if request.session.get("role") != "Admin":
        messages.error(request, "Only database managers can rename halls.")
        return redirect("login")

    message = None

    if request.method == "POST":
        old_name = request.POST.get("old_name", "").strip()
        new_name = request.POST.get("new_name", "").strip()

        if not old_name or not new_name:
            messages.error(request, "Both old and new hall names are required.")
        else:
            try:
                with connection.cursor() as cursor:
                    # Check if hall with old_name exists
                    cursor.execute("SELECT 1 FROM Hall WHERE hall_name = %s", [old_name])
                    if cursor.fetchone() is None:
                        messages.error(request, f"No hall found with name '{old_name}'.")
                    else:
                        # Check if new_name already exists
                        cursor.execute("SELECT 1 FROM Hall WHERE hall_name = %s", [new_name])
                        if cursor.fetchone():
                            messages.error(request, f"A hall with the name '{new_name}' already exists.")
                        else:
                            cursor.execute("UPDATE Hall SET hall_name = %s WHERE hall_name = %s", [new_name, old_name])
                            messages.success(request, f"Hall successfully renamed from '{old_name}' to '{new_name}'.")
            except Exception as e:
                messages.error(request, f"Rename failed: {str(e)}")

    return render(request, 'chess/rename_hall.html')

