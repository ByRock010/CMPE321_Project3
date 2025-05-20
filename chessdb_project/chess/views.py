import hashlib

from django import forms
from django.contrib import messages
from django.db import connection
from django.http import Http404
from django.shortcuts import redirect, render


import re
from django.core.exceptions import ValidationError

def validate_password_strength(password):
    if len(password) < 8:
        raise ValidationError("Password must be at least 8 characters.")
    if not re.search(r'[A-Z]', password):
        raise ValidationError("Password must include an uppercase letter.")
    if not re.search(r'[a-z]', password):
        raise ValidationError("Password must include a lowercase letter.")
    if not re.search(r'[0-9]', password):
        raise ValidationError("Password must include a digit.")
    if not re.search(r'[^A-Za-z0-9]', password):
        raise ValidationError("Password must include a special character.")



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
                    # ✅ Hall-table validation check
                    cur.execute("""
                        SELECT 1 FROM ChessTable
                        WHERE table_id = %s AND hall_id = %s
                    """, [data['table_id'], data['hall_id']])
                    if not cur.fetchone():
                        messages.error(request, "Selected table does not belong to the selected hall.")
                        return render(request, 'chess/create_match.html', {'form': form})

                    # Proceed only if the above passes
                    cur.callproc("create_match", [
                        data['white_player'],
                        data['white_team_id'],
                        data['black_team_id'],
                        data['match_date'],
                        data['time_slot'],
                        data['hall_id'],
                        data['table_id'],
                        data['arbiter_username'],
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
            coach_username = request.session.get('username')

            if not coach_username:
                messages.error(request, "You must be logged in as a coach.")
                return redirect('login')

            try:
                with connection.cursor() as cur:
                    # Step 1: Get match info
                    cur.execute("""
                        SELECT black_player_team_id, match_date, time_slot
                        FROM ChessMatch
                        WHERE match_id = %s
                    """, [match_id])
                    result = cur.fetchone()

                    if not result:
                        messages.error(request, "Match not found.")
                        return redirect('assign_black', match_id=match_id)

                    match_team_id, match_date, time_slot = result

                    if match_team_id != data['black_team_id']:
                        messages.error(request, "This match does not use the selected team as the black side.")
                        return redirect('assign_black', match_id=match_id)

                    # Step 2: Check coach's contract
                    cur.execute("""
                        SELECT 1 FROM Coach_Team_Agreement
                        WHERE coach_username = %s AND team_id = %s
                          AND CURDATE() BETWEEN contract_start AND contract_finish
                    """, [coach_username, data['black_team_id']])
                    if not cur.fetchone():
                        messages.error(request, "You do not have an active contract with this team.")
                        return redirect('assign_black', match_id=match_id)

                    # Step 3: Check if player is from the same team
                    cur.execute("""
                        SELECT team_id FROM Player_Team
                        WHERE player_username = %s
                    """, [data['black_player']])
                    player_team_row = cur.fetchone()

                    if not player_team_row or player_team_row[0] != data['black_team_id']:
                        messages.error(request, "Selected player does not belong to this team.")
                        return redirect('assign_black', match_id=match_id)

                    # Step 4: Check if player is available at that date and time
                    cur.execute("""
                        SELECT 1 FROM ChessMatch
                        WHERE (white_player = %s OR black_player = %s)
                          AND match_date = %s
                          AND time_slot = %s
                    """, [data['black_player'], data['black_player'], match_date, time_slot])
                    if cur.fetchone():
                        messages.error(request, "This player already has a match at the same time.")
                        return redirect('assign_black', match_id=match_id)

                    # Step 5: Call the stored procedure to assign
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


def coach_unassigned_matches(request):
    username = request.session.get("username")
    if not username:
        messages.error(request, "You must be logged in as a coach.")
        return redirect("login")

    with connection.cursor() as cur:
        cur.execute("""
            SELECT match_id, match_date, time_slot
            FROM ChessMatch
            WHERE black_player IS NULL 
              AND black_player_team_id IN (
                  SELECT team_id
                  FROM Coach_Team_Agreement
                  WHERE coach_username = %s
                    AND CURDATE() BETWEEN contract_start AND contract_finish
              )
            ORDER BY match_date, time_slot
        """, [username])
        matches = [dict(zip([col[0] for col in cur.description], row)) for row in cur.fetchall()]

    return render(request, 'chess/coach_unassigned_matches.html', {'matches': matches})





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

            with connection.cursor() as cursor:
                print("Calling SubmitRating with:", match_id, rating, username)
                cursor.callproc("SubmitRating", [match_id, rating, username])

            messages.success(request, "Rating submitted successfully!")
            return redirect("submit_rating")

        except Exception as e:
            print("Rating submission failed:", str(e))
            messages.error(request, f"Submission failed: {str(e)}")
            return redirect("submit_rating")  # Redirect to avoid re-posting on refresh

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
    with connection.cursor() as cursor:
        cursor.execute("SELECT team_id, team_name FROM Team ORDER BY team_id")
        teams = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]

    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        name = request.POST.get("name")
        surname = request.POST.get("surname")
        nationality = request.POST.get("nationality")
        date_of_birth = request.POST.get("date_of_birth")
        elo = request.POST.get("elo_rating")
        fide_id = request.POST.get("fide_id")
        title = request.POST.get("title_id")
        team_id = request.POST.get("team_id")

        try:
            validate_password_strength(password)
            with connection.cursor() as cursor:
                cursor.callproc('AddUser', [username, password, name, surname, nationality, 'Player'])
                cursor.callproc('AddPlayer', [username, date_of_birth, elo, fide_id, title])
                cursor.execute("INSERT INTO Player_Team (player_username, team_id) VALUES (%s, %s)", [username, team_id])
                messages.success(request, "Player added and assigned to team successfully!")
        except ValidationError as ve:
            messages.error(request, str(ve))
        except Exception as e:
            messages.error(request, f"Error: {str(e)}")

    return render(request, 'chess/addplayer.html', {'teams': teams})

    # Fetch team list regardless of POST or GET
    with connection.cursor() as cursor:
        cursor.execute("SELECT team_id, team_name FROM Team ORDER BY team_id")
        teams = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]

    return render(request, 'chess/addplayer.html', {'teams': teams})





def add_coach(request):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT t.team_id, t.team_name
            FROM Team t
            WHERE t.team_id NOT IN (
                SELECT team_id FROM Coach_Team_Agreement
                WHERE CURDATE() BETWEEN contract_start AND contract_finish
            )
            ORDER BY t.team_id
        """)
        teams = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]

    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        name = request.POST.get("name")
        surname = request.POST.get("surname")
        nationality = request.POST.get("nationality")
        team_id = request.POST.get("team_id")

        try:
            validate_password_strength(password)
            with connection.cursor() as cursor:
                cursor.callproc('AddUser', [username, password, name, surname, nationality, 'Coach'])
                cursor.callproc('AddCoach', [username])
                cursor.execute("""
                    INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
                    VALUES (%s, %s, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 YEAR))
                """, [username, team_id])
                messages.success(request, "Coach added and assigned to team successfully!")
        except ValidationError as ve:
            messages.error(request, str(ve))
        except Exception as e:
            messages.error(request, f"Error: {str(e)}")

    return render(request, 'chess/addcoach.html', {'teams': teams})



def add_arbiter(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        name = request.POST.get("name")
        surname = request.POST.get("surname")
        nationality = request.POST.get("nationality")
        experience = request.POST.get("experience")

        try:
            validate_password_strength(password)
            with connection.cursor() as cursor:
                cursor.callproc('AddUser', [username, password, name, surname, nationality, 'Arbiter'])
                cursor.callproc('AddArbiter', [username, experience])
                messages.success(request, "Arbiter added successfully!")
        except ValidationError as ve:
            messages.error(request, str(ve))
        except Exception as e:
            messages.error(request, f"Error: {str(e)}")

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

