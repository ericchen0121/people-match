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

  fetchGames: (sport) ->
    url = "http://api.sportsdatallc.org/#{sport}-t1/2014/REG/16/schedule.xml?api_key=u5jw8rhnqtqvr5k8zwgnjm3k"
    APIresponse = HTTP.get url, { timeout: 10000 }

    games = []

    if APIresponse.statusCode == 200
      parser = new xml2js.Parser()
      parser.parseString APIresponse.content, (err, result) ->
        games = result.games.game

    for game in games
      # ensure its not a duplicate before inserting
      unless Events.findOne({"api.SDGameId": game.$.id})
        # add sport
        newGame = _.extend(game.$, { sport: sport })

        # insert
        Events.insert(newGame)

# POTENTIALLY MAKE THIS WEB UI OR CRON JOB
# Meteor.call 'fetchGames', 'nfl'
