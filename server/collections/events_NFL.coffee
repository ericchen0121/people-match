#https://github.com/matb33/meteor-collection-hooks#beforeupdateuserid-doc-fieldnames-modifier-options
# 
Events.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set.createdAt = modifier.$set.createdAt || new Date().toISOString()
  modifier.$set.updatedAt = new Date().toISOString()

Meteor.methods

  getEventsNFL: (sport, week) ->
    if sport == 'NFL'
      sched = JSON.parse(sd.NFLApi.getWeeklySchedule week)
      events = sched.games
    # events is an Array when multiple, but a dictionary when single 
    if Array.isArray(events)
      for event in events
        Meteor.call 'updateEventNFL', event, week
    else
      Meteor.call 'updateEventNFL', events, week

  updateEventNFL: (event, week) ->
    Events.update({
        api: { SDGameId: event.id }
      }, 
      { 
        $set: 
          api: 
            SDGameId: event.id
          sport: 'NFL'
          week: week
          status: event.status
          home: event.home
          away: event.away
          startsAt: new Date(event.scheduled).toISOString()
      },
      { upsert: true }
    )
