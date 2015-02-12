#https://github.com/matb33/meteor-collection-hooks#beforeupdateuserid-doc-fieldnames-modifier-options
# 
Events.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set.createdAt = modifier.$set.createdAt || new Date().toISOString()
  modifier.$set.updatedAt = new Date().toISOString()

Meteor.methods

  getEventsNFL: (sport, week) ->
    if sport == 'NFL'
      sched = sd.NFLApi.getWeeklySchedule week
      events = sched.games.game

    # events is an Array when multiple, but an dictionary when single 
    if Array.isArray(events)
      for event in events
        Meteor.call 'updateEvent', event, sport
    else
      Meteor.call 'updateEvent', events, sport

  updateEvent: (event, sport) ->
    Events.update({
        api: { SDGameId: event.id }
      }, 
      { 
        $set: 
          api: 
            SDGameId: event.id
          sport: sport
          status: event.status
          home: event.home
          away: event.away
          startsAt: new Date(event.scheduled).toISOString()
      },
      { upsert: true }
    )

# Meteor.call 'getEventsNFL', 'NFL', 4
