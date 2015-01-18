Events.before.insert (userId, doc) ->
  # BASED ON SPORTS DATA API, USE BRIDGE OR ADAPER PATTERN HERE
  doc.createdAt = Date.now()

  # ======= transform the doc =========
  # convert time
  # http://stackoverflow.com/questions/18896470/mongodb-converting-isodate-to-numerical-value
  doc.startsAt = new Date(doc.scheduled).getTime() # get numeric from ISODate

  # rename fields
  doc.api = doc.api || {} # API namespace, TODO: doc.api ?= {}
  doc.api.SDGameId = doc.id
  delete doc.id

  # delete fields
  delete doc.home_rotation
  delete doc.away_rotation

Meteor.methods

  getEvents: (sport, week) ->
    if sport == 'NFL'
      sched = sd.NFLApi.getWeeklySchedule week
      events = sched.games.game

      for event in events
        unless Events.findOne({"api.SDGameId": event.id}) # check duplicate
          event.sport = sport # add event info
          Events.insert(event)

# Meteor.call 'getEvents', 'NFL', 3
