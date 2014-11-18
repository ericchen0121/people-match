Template.nflPlayersList.helpers

  nflPlayers: ->
    if Session.get 'showQB'
      NflPlayers.find({position: 'QB'}, {sort: {name: 1}})
    else
      NflPlayers.find({}, {sort: {name: 1}})

  showQB: ->
    Session.get 'showQB'

# TODO: make this filter generic and accept an argument
  filterQBCount: ->
    NflPlayers.find({position: 'QB'}).count()

  totalNflPlayersCount: ->
    NflPlayers.find({}).count()

Template.nflPlayersList.events

  'change .show-qb input': (event) ->
    Session.set 'showQB', event.target.checked
