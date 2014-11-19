Template.nflPlayersList.helpers

  nflPlayers: ->
    positionValue = Session.get 'nflPosition'

    if positionValue
      NflPlayers.find({position: positionValue}, {sort: {last_name: 1}})
    else
      # temporary
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
