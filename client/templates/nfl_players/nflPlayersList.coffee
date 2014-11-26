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
    else # default option
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

Template.nflPlayersListLayout.events

  'change #positionDropdown': (event) ->
    console.log event.target.value
    Session.set 'nflPosition', event.target.value
    console.log Session.get 'nflPosition'

  'change #teamDropdown': (event) ->
    Session.set 'nflTeam', event.target.value

