Meteor.methods
  getEventStatNBA: (SDgameId) ->
    eventStat = sd.NBAApi.getGameSummary(SDgameId)
