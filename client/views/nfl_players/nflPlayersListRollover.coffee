Template.teamRollover.helpers

  nflTeams: ->
    NflTeams.find()

Template.teamRollover.events

  'click .BUF, mouseenter .BUF': (event) ->
    Session.set 'nflTeam', 'Buffalo Bills'

  'click .WAS, mouseenter .WAS': (event) ->
    Session.set 'nflTeam', 'Washington Redskins'

  'click .MIA, mouseenter .MIA': (event) ->
    Session.set 'nflTeam', 'Miami Dolphins'

  'click .JAC, mouseenter .JAC': (event) ->
    Session.set 'nflTeam', 'Jacksonville Jaguars'

  'click .NYJ, mouseenter .NYJ': (event) ->
    Session.set 'nflTeam', 'New York Jets'

  'click .KC, mouseenter .KC': (event) ->
    Session.set 'nflTeam', 'Kansas City Chiefs'

  'click .NE, mouseenter .NE': (event) ->
    Session.set 'nflTeam', 'New England Patriots'

  'click .DAL, mouseenter .DAL': (event) ->
    Session.set 'nflTeam', 'Dallas Cowboys'

  'click .NYG, mouseenter .NYG': (event) ->
    Session.set 'nflTeam', 'New York Giants'

  'click .BAL, mouseenter .BAL': (event) ->
    Session.set 'nflTeam', 'Baltimore Ravens'

  'click .PHI, mouseenter .PHI': (event) ->
    Session.set 'nflTeam', 'Philadelphia Eagles'

  'click .DEN, mouseenter .DEN': (event) ->
    Session.set 'nflTeam', 'Denver Broncos'

  'click .TB, mouseenter .TB': (event) ->
    Session.set 'nflTeam', 'Tampa Bay Buccaneers'

  'click .OAK, mouseenter .OAK': (event) ->
    Session.set 'nflTeam', 'Oakland Raiders'

  'click .SD, mouseenter .SD': (event) ->
    Session.set 'nflTeam', 'San Diego Chargers'

  'click .ARI, mouseenter .ARI': (event) ->
    Session.set 'nflTeam', 'Arizona Cardinals'

  'click .SF, mouseenter .SF': (event) ->
    Session.set 'nflTeam', 'San Francisco 49ers'

  'click .SEA, mouseenter .SEA': (event) ->
    Session.set 'nflTeam', 'Seattle Seahawks'

  'click .STL, mouseenter .STL': (event) ->
    Session.set 'nflTeam', 'St. Louis Rams'

  'click .CIN, mouseenter .CIN': (event) ->
    Session.set 'nflTeam', 'Cincinnati Bengals'

  'click .DET, mouseenter .DET': (event) ->
    Session.set 'nflTeam', 'Detroit Lions'

  'click .CLE, mouseenter .CLE': (event) ->
    Session.set 'nflTeam', 'Cleveland Browns'

  'click .PIT, mouseenter .PIT': (event) ->
    Session.set 'nflTeam', 'Pittsburgh Steelers'

  'click .CHI, mouseenter .CHI': (event) ->
    Session.set 'nflTeam', 'Chicago Bears'

  'click .GB, mouseenter .GB': (event) ->
    Session.set 'nflTeam', 'Green Bay Packers'

  'click .MIN, mouseenter .MIN': (event) ->
    Session.set 'nflTeam', 'Minnesota Vikings'

  'click .HOU, mouseenter .HOU': (event) ->
    Session.set 'nflTeam', 'Houston Texans'

  'click .IND, mouseenter .IND': (event) ->
    Session.set 'nflTeam', 'Indianapolis Colts'

  'click .TEN, mouseenter .TEN': (event) ->
    Session.set 'nflTeam', 'Tennessee Titans'

  'click .ATL, mouseenter .ATL': (event) ->
    Session.set 'nflTeam', 'Atlanta Falcons'

  'click .CAR, mouseenter .CAR': (event) ->
    Session.set 'nflTeam', 'Carolina Panthers'
