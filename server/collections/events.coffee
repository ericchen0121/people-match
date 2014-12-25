Events.before.insert (userId, doc) ->
  # BASED ON SPORTS DATA API, USE BRIDGE OR ADAPER PATTERN HERE
  # add
  doc.createdAt = Date.now()

  # transform
  # convert time
  # http://stackoverflow.com/questions/18896470/mongodb-converting-isodate-to-numerical-value
  doc.startsAt = new Date(doc.scheduled).getTime() # get numeric from ISODate

  # rename
  doc.api = doc.api || {} # API namespace
  doc.api.SDGameId = doc.id
  delete doc.id

  # delete
  delete doc.home_rotation
  delete doc.away_rotation

Meteor.methods

  getEventsNFL: (week) ->
    games = []

    sched = sd.NFLApi.getWeeklySchedule week
    games = sched.games.game

    for game in games
      console.log game
      # check for duplicate
      unless Events.findOne({"api.SDGameId": game.$.id})
        # add sport
        newGame = _.extend(game.$, { sport: 'nfl' })
        Events.insert(newGame)

# Meteor.call 'getEventsNFL', 17
