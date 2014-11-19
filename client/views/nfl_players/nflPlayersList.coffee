Template.nflPlayersList.helpers

  nflPlayers: ->
    positionValue = Session.get 'nflPosition'

    if positionValue
      NflPlayers.find({position: positionValue}, {sort: {last_name: 1}})
    else
      # temporarily choosing a small number of players
      NflPlayers.find({position: 'S'}, {sort: {last_name: 1}})
      # find all
      # NflPlayers.find({}, {sort: {name: 1}})

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

Template.positionDropdown.helpers

  positions: ->
    ['QB', 'RB', 'WR', 'TE', 'FB',  'C', 'OG', 'OT', 'LB', 'CB', 'SS',  'S', 'DT', 'DE', 'PK']

Template.playerDescriptionVisual.helpers
  
  # obj is passed in as an argument in the template helper. 
  # The two attributes of this object are 
  # `espn_id`: the id of the player's url page on espn.com
  # `espn_size` String: the size to fetch from espn's cdn 
  # 
  playerImageSrc: (obj) ->

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


