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

  checkBoxShowQB: ->
    Session.get 'showQB'

  # TODO: make this filter generic and accept an argument
  filterQBCount: ->
    NflPlayers.find({position: 'QB'}).count()

Template.nflPlayersList.events

  'change #positionDropdown': (event) ->
    Session.set 'nflPosition', event.target.value

  'change #teamDropdown': (event) ->
    Session.set 'nflTeam', event.target.value

Template.positionDropdown.helpers

  positions: ->
    ['All', 'QB', 'RB', 'WR', 'TE', 'FB',  'C', 'OG', 'OT', 'LB', 'CB', 'SS',  'S', 'DT', 'DE', 'PK']

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


Template.playerDescriptionVisual.helpers
  
  # obj is passed in as an argument in the template helper. 
  # The two attributes of this object are 
  # `espn_id`: the id of the player's url page on espn.com
  # `espn_size` String: the size to fetch from espn's cdn 
  # 
  playerImageESPNSrc: (obj) ->

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


