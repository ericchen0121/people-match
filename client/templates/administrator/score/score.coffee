Template.score.helpers

  # TODO: Run a CRON job once a day, or multiple times a day, to constantly get new events into the system
  # with new status.
  # find events that are upcoming ie. `created`, or live, ie. `inprogress`
  # these are states given bt the SD API.
  # 
  liveEvents:  ->
    # TODO: instead of basing this on the lifecycle of the status, much better to base it on the day
    # If its on the same day as today...
    # Events.find({ status: {$in: ['inprogress', 'created', 'complete']} }) # is better to not have all closed ones and cluttter
    # Events.find({ status: {$in: ['inprogress', 'created', 'complete', 'closed']} })
    # Events.find({ status: {$in: ['scheduled']} })
    Events.find { startsAt: mq.past }

Template.score.events
  # TODO: un-hardcode this.
  # NOTE: NBA events are all created at the beginning of the year
  'click .score-week-all': (e) ->
    week = $('select#score-schedule-select').val()
    
    weeklyEvents = Events.find({ week: week }).fetch()
    waitFactor = weeklyEvents.length
    waitFactorAPI = 0
    # console.log waitFactorAPI, waitfactor, weeklyEvents

    # Coffeescript closures
    # http://firstdoit.com/closures/
    # 
    # weeklyEvents.forEach (event, i) ->
    #   console.log '----------------', event
    #   Meteor.setTimeout( ->
    #     Meteor.call 'getEventStatsNFL', 'NFL', parseInt(event.week), event.away, event.home
    #   , waitFactorAPI * i)

    Meteor.setTimeout( ->
      weeklyEvents.forEach (event, i) ->
        Meteor.setTimeout( ->
          Meteor.call 'convertToAthleteEventStatsNFL', event.api.SDGameId
        , 1000 * i)
    , waitFactorAPI * waitFactor)

    Meteor.setTimeout( ->
      weeklyEvents.forEach (event, i) ->
        Meteor.setTimeout( ->
          console.log 'batchAthleteEventScoringNFL------', i
          Meteor.call 'batchAthleteEventScoringNFL', event.api.SDGameId
        , 1000 * i)
    , waitFactorAPI * waitFactor + 1000 * waitFactor)

    Meteor.setTimeout( ->
      weeklyEvents.forEach (event, i) ->
        Meteor.setTimeout( ->
          console.log 'addScoreByGame-----------------', i
          Meteor.call 'addScoreByGame', 'NFL', event.api.SDGameId
        , 3000 * i)
    , waitFactorAPI * waitFactor + 2000 * waitFactor)

    Meteor.setTimeout( ->
      weeklyEvents.forEach (event, i) ->
        Meteor.setTimeout( ->
          console.log 'addTotalScoreAllEntries---------------', i
          Meteor.call 'addTotalScoreAllEntries', event.api.SDGameId
        , 3000 * i)
    , waitFactorAPI * waitFactor + 5000 * waitFactor)
    # , waitFactorAPI * waitFactor)

    Meteor.setTimeout( ->
      weeklyEvents.forEach (event, i) ->
        Meteor.setTimeout( ->
          console.log 'rankContestsForEvent---------------', i
          Meteor.call 'rankContestsForEvent', event.api.SDGameId
        , 1000 * i)
    , waitFactorAPI * waitFactor + 8000 * waitFactor)

  'click .score-it-all': (e) ->
    event = @
    sport = event.sport
    Meteor.call 'updateEventStatus', @

    switch sport
      when 'NFL'
        Meteor.call 'getEventStatsNFL', 'NFL', 4, event.away, event.home
        Meteor.call 'convertToAthleteEventStatsNFL', event.api.SDGameId
        Meteor.call 'batchAthleteEventScoringNFL', event.api.SDGameId
        Meteor.call 'addScoreByGame', 'NFL', event.api.SDGameId

      when 'NBA'
        Meteor.call 'getEventStatNBA', event.api.SDGameId 
        Meteor.call 'convertToAthleteEventStatsNBA', event.api.SDGameId
        Meteor.call 'addScoreByGame', 'NBA', event.api.SDGameId

    Meteor.call 'addTotalScoreAllEntries', event.api.SDGameId
    Meteor.call 'rankContestsForEvent', event.api.SDGameId

  'click .update-events-status': (e) ->
    event = @
    Meteor.call 'updateEventStatus', @

  # TODO: un-hardcode this.
  # Base this on a call to WEEKLY or DAILY Schedule thru API. 
  'click .update-event-stats': (e) ->
    event = @
    sport = event.sport

    switch sport
      when 'NFL' #change all event Sport attrs to "NFL"
        Meteor.call 'getEventStatsNFL', 'NFL', 4, event.away, event.home # TODO: change this to be extensible, no hardcoded Week 4!, which means, probably must store 4 on the event itself
      when 'NBA'
        Meteor.call 'getEventStatNBA', event.api.SDGameId 

  'click .create-athlete-event-stats': (e) ->
    event = @
    sport = event.sport

    switch sport
      when 'NFL'
        Meteor.call 'convertToAthleteEventStatsNFL', event.api.SDGameId
      when 'NBA'
        Meteor.call 'convertToAthleteEventStatsNBA', event.api.SDGameId
        # This also adds to AthleteEventScores

  'click .score-stats': (e) ->
    event = @
    sport = event.sport

    switch sport
      when 'NFL'
        Meteor.call 'addScoreByGame', 'NFL', event.api.SDGameId
      when 'NBA'
        # Previous method already added to AthleteEventScores
        Meteor.call 'addScoreByGame', 'NBA', event.api.SDGameId

  'click .total-score-to-entries-week-all': (e) ->
    week = $('select#total-score-schedule-select').val()
    weeklyEvents = Events.find({ week: week }).fetch()
    for event in weeklyEvents
      Meteor.call 'addTotalScoreAllEntries', event.api.SDGameId

  'click .rank-entries-week-all': (e) ->
    week = $('select#rank-entries-schedule-select').val()
    weeklyEvents = Events.find({ week: week }).fetch()
    for event in weeklyEvents
      Meteor.call 'rankContestsForEvent', event.api.SDGameId

Template.score.rendered = ->
  Session.setJSON 'fixtureNFLWeekSelection', '1'