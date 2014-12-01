Template.teamSelect.helpers

  nflTeams: ->
    NflTeams.find()

  # Returns 'active' as a class if the team is active
  nflTeamActive: (team) ->
    if team == Session.get 'nflTeam'
      return 'active'
    else
      ''

Template.teamSelect.events
# TODO: match to the nflTeam helper
  'click .BUF': (event) ->
    Session.set 'nflTeam', 'Buffalo Bills'

  'click .WAS': (event) ->
    Session.set 'nflTeam', 'Washington Redskins'

  'click .MIA': (event) ->
    Session.set 'nflTeam', 'Miami Dolphins'

  'click .JAC': (event) ->
    Session.set 'nflTeam', 'Jacksonville Jaguars'

  'click .NYJ': (event) ->
    Session.set 'nflTeam', 'New York Jets'

  'click .KC': (event) ->
    Session.set 'nflTeam', 'Kansas City Chiefs'

  'click .NE': (event) ->
    Session.set 'nflTeam', 'New England Patriots'

  'click .DAL': (event) ->
    Session.set 'nflTeam', 'Dallas Cowboys'

  'click .NYG': (event) ->
    Session.set 'nflTeam', 'New York Giants'

  'click .BAL': (event) ->
    Session.set 'nflTeam', 'Baltimore Ravens'

  'click .PHI': (event) ->
    Session.set 'nflTeam', 'Philadelphia Eagles'

  'click .DEN': (event) ->
    Session.set 'nflTeam', 'Denver Broncos'

  'click .TB': (event) ->
    Session.set 'nflTeam', 'Tampa Bay Buccaneers'

  'click .OAK': (event) ->
    Session.set 'nflTeam', 'Oakland Raiders'

  'click .SD': (event) ->
    Session.set 'nflTeam', 'San Diego Chargers'

  'click .ARI': (event) ->
    Session.set 'nflTeam', 'Arizona Cardinals'

  'click .SF': (event) ->
    Session.set 'nflTeam', 'San Francisco 49ers'

  'click .SEA': (event) ->
    Session.set 'nflTeam', 'Seattle Seahawks'

  'click .STL': (event) ->
    Session.set 'nflTeam', 'St. Louis Rams'

  'click .CIN': (event) ->
    Session.set 'nflTeam', 'Cincinnati Bengals'

  'click .DET': (event) ->
    Session.set 'nflTeam', 'Detroit Lions'

  'click .CLE': (event) ->
    Session.set 'nflTeam', 'Cleveland Browns'

  'click .PIT': (event) ->
    Session.set 'nflTeam', 'Pittsburgh Steelers'

  'click .CHI': (event) ->
    Session.set 'nflTeam', 'Chicago Bears'

  'click .GB': (event) ->
    Session.set 'nflTeam', 'Green Bay Packers'

  'click .MIN': (event) ->
    Session.set 'nflTeam', 'Minnesota Vikings'

  'click .HOU': (event) ->
    Session.set 'nflTeam', 'Houston Texans'

  'click .IND': (event) ->
    Session.set 'nflTeam', 'Indianapolis Colts'

  'click .TEN': (event) ->
    Session.set 'nflTeam', 'Tennessee Titans'

  'click .ATL': (event) ->
    Session.set 'nflTeam', 'Atlanta Falcons'

  'click .CAR': (event) ->
    Session.set 'nflTeam', 'Carolina Panthers'

  'click .NO': (event) ->
    Session.set 'nflTeam', 'New Orleans Saints'

