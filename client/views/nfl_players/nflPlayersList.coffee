Template.nflPlayersList.helpers

  nflPlayers: ->

    # create query options
    options = {}
    sortOptions = {sort: {last_name: 1}}
    position = Session.get 'nflPosition'
    team = Session.get 'nflTeam'

    if position
      if position == 'All'
        # if 'All', then remove the filter from the query!
        delete options['position'] if options.position
      else
        options.position = Session.get 'nflPosition'
    else # default
      options.position = 'QB'

    if team
      if team == 'All'
                # if 'All', then remove the filter from the query!
        delete options[team] if options.team
      else
        options.team = Session.get 'nflTeam'
    else
      options.team = 'Baltimore Ravens'

    NflPlayers.find(options, sortOptions)

  # TODO: refactor this to be based on the other helper value
  nflPositionCount: ->
    positionValue = Session.get 'nflPosition'

    if positionValue
      NflPlayers.find({position: positionValue}, {sort: {last_name: 1}}).count()
    else
      # temporary
      NflPlayers.find({position: 'S'}, {sort: {last_name: 1}}).count()

  totalNflPlayersCount: ->
    NflPlayers.find({}).count()

Template.nflPlayersList.events

  'change #positionDropdown': (event) ->
    Session.set 'nflPosition', event.target.value

  'change #teamDropdown': (event) ->
    Session.set 'nflTeam', event.target.value

Template.positionDropdown.helpers

  positions: ->
    ['All', 'QB', 'RB', 'WR', 'TE', 'FB',  'C', 'OG', 'OT', 'LB', 'CB', 'SS', 'FS', 'S', 'DT', 'DE', 'PK']

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

Template.teamDropdown.helpers

  nflTeams: ->
    [ 'All'
      'Buffalo Bills',
      'Washington Redskins',
      'Miami Dolphins',
      'Jacksonville Jaguars',
      'New York Jets',
      'Kansas City Chiefs',
      'New England Patriots',
      'Dallas Cowboys',
      'New York Giants',
      'Baltimore Ravens',
      'Philadelphia Eagles',
      'Denver Broncos',
      'Tampa Bay Buccaneers',
      'Oakland Raiders',
      'San Diego Chargers',
      'Arizona Cardinals',
      'San Francisco 49ers',
      'Seattle Seahawks',
      'St. Louis Rams',
      'Cincinnati Bengals',
      'Detroit Lions',
      'Cleveland Browns',
      'Pittsburgh Steelers',
      'Chicago Bears',
      'Green Bay Packers',
      'Minnesota Vikings',
      'Houston Texans',
      'Indianapolis Colts',
      'Tennessee Titans',
      'Atlanta Falcons',
      'Carolina Panthers'
    ]

Template.teamRollover.helpers
  
  nflTeams: ->
    [
      {team: 'Buffalo Bills', abbr: 'BUF'},
      {team: 'Washington Redskins', abbr: 'WAS'},
      {team: 'Miami Dolphins', abbr: 'MIA'},
      {team: 'Jacksonville Jaguars', abbr: 'JAC'},
      {team: 'New York Jets', abbr: 'NYJ'},
      {team: 'Kansas City Chiefs', abbr: 'KC'},
      {team: 'New England Patriots', abbr: 'NE'},
      {team: 'Dallas Cowboys', abbr: 'DAL'},
      {team: 'New York Giants', abbr: 'NYG'},
      {team: 'Baltimore Ravens', abbr: 'BAL'},
      {team: 'Philadelphia Eagles', abbr: 'PHI'},
      {team: 'Denver Broncos', abbr: 'DEN'},
      {team: 'Tampa Bay Buccaneers', abbr: 'TB'},
      {team: 'Oakland Raiders', abbr: 'OAK'},
      {team: 'San Diego Chargers', abbr: 'SD'},
      {team: 'Arizona Cardinals', abbr: 'ARI'},
      {team: 'San Francisco 49ers', abbr: 'SF'},
      {team: 'Seattle Seahawks', abbr: 'SEA'},
      {team: 'St. Louis Rams', abbr: 'STL'},
      {team: 'Cincinnati Bengals', abbr: 'CIN'},
      {team: 'Detroit Lions', abbr: 'DET'},
      {team: 'Cleveland Browns', abbr: 'CLE'},
      {team: 'Pittsburgh Steelers', abbr: 'PIT'},
      {team: 'Chicago Bears', abbr: 'CHI'},
      {team: 'Green Bay Packers', abbr: 'GB'},
      {team: 'Minnesota Vikings', abbr: 'MIN'},
      {team: 'Houston Texans', abbr: 'HOU'},
      {team: 'Indianapolis Colts', abbr: 'IND'},
      {team: 'Tennessee Titans', abbr: 'TEN'},
      {team: 'Atlanta Falcons', abbr: 'ATL'},
      {team: 'Carolina Panthers', abbr: 'CAR'}
    ]

Template.playerCardPhoto.helpers

  # obj is passed in as an argument in the template helper.
  # The two attributes of this object are
  # `espn_id`: the id of the player's url page on espn.com
  # `espn_size` String: the size to fetch from espn's cdn
  #
  playerImageESPN: (obj) ->

    if obj.hash.espn_size
      size = switch obj.hash.espn_size
        when 'small' then '&w=137&h=100'
        when 'medium' then '&w=274&h=200'
        when 'large' then '&w=350&h=255'
        when 'original' then ''
        when 'micro' then '&w=68&h=50'
        else ''
    else size = ''

    'http://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/' + obj.hash.espn_id + '.png' + size

Template.nflPlayerSearchResults.helpers

  # potentially should be global helper function
  searchResultsExist: ->
    searchInstance = EasySearch.getComponentInstance {index: 'nflPlayersSearch'}

    return searchInstance.get('total') != 0

