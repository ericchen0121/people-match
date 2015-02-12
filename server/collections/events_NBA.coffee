Meteor.methods

  getNBADailyScheduleEvents: (sport, year, month, day) ->
    if sport == 'NBA'
      sched = JSON.parse(sd.NBAApi.getDailySchedule(year, month, day))


  getNBAYearScheduleEvents: (sport) ->
    if sport == 'NBA'
      yearlysched = JSON.parse(sd.NBAApi.getSeasonSchedule())

      for game in yearlysched.games
        Meteor.call 'updateEventNBA', game, sport
        
  updateEventNBA: (event, sport) ->
    Events.update({
        api: { SDGameId: event.id }
      }, 
      { 
        $set: 
          api: 
            SDGameId: event.id
            SDTeamIds: [ event.home.id, event.away.id ]
          sport: sport
          status: event.status
          coverage: event.coverage
          startsAt: new Date(event.scheduled).toISOString()
          home: event.home.alias
          away: event.away.alias
      },
      { upsert: true }
    )

# Meteor.call 'getNBADailyScheduleEvents', 'NBA', 2014, 1, 21
# Meteor.call 'getNBAYearScheduleEvents', 'NBA'