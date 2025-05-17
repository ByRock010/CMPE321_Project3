from django.shortcuts import render, redirect
from django.db import connection
from django.http import Http404
from django import forms
from django.contrib import messages


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
