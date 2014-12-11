Template.contestLineupContainer.helpers

  availablePlayers: ->
    NflPlayers.find({})

  salaryRemaining: ->
    60000

  salaryRemainingAvg: ->
    60000 / 12
