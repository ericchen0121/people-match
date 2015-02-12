Meteor.methods
  getEventStatNBA: (SDgameId) ->
    eventStat = JSON.parse(sd.NBAApi.getGameSummary(SDgameId))
    sport = 'NBA'

    if eventStat
      EventStats.update({
          api: { SDGameId: eventStat.id }
        },
        {
          $set: 
            api: 
              SDGameId: eventStat.id
            sport: sport
            status: eventStat.status
            home: eventStat.home
            away: eventStat.away
            coverage: eventStat.coverage
            scheduled: eventStat.scheduled
            duration: eventStat.duration
            attendance: eventStat.attendance
            lead_changes: eventStat.lead_changes
            times_tied: eventStat.times_tied
            clock: eventStat.clock
            quarter: eventStat.quarter
            venue: eventStat.venue
        }, 
        { upsert: true }
      )

      console.log 'EVENTSTAT: ', eventStat, eventStat.status

      Events.update({
        "api.SDGameId": eventStat.id
      },
      {
        $set:
          status: eventStat.status
      })