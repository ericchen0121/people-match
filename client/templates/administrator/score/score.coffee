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
  'click .update-team-rosters': (e) ->
    Meteor.call 'updateAllTeamRostersNFL'
    
  'click .score-week-all': (e) ->
    week = $('select#score-schedule-select').val()
    
    weeklyEvents = Events.find({ week: week }).fetch()
    waitFactor = weeklyEvents.length
    waitAPI = 3000 # generally found 3 seconds is a good time for all API calls and processing for all teams
    waitStandard = 1000
    waitA = waitAPI * waitFactor
    waitB = waitStandard * waitFactor
    
    # Coffeescript closures
    # http://firstdoit.com/closures/
    
    # ARCHITECTURE
    # Updating scores works like this
    # STEP 1: Sports DataAPI -> 
    # STEP 2: EventStats collection -> 
    # STEP 3: AthleteEventStats collection ->
    # STEP 4: AthleteEventScores collection ->
    # STEP 5: Entries collection
    # STEP 6: Ranking Entries in the Contest by Top Score
    #

    # Have these call methods in order, setting longer and longer timeouts, so they are queued up
    #
    # STEP 1: 
    #
    weeklyEvents.forEach (event, i) ->
      console.log '----------------', event
      Meteor.setTimeout( ->
        Meteor.call 'getEventStatsNFL', 'NFL', parseInt(event.week), event.away, event.home
      , waitAPI * i) # set progressively longer and longer timeouts so Meteor calls are called in order

    # STEP 2: 
    #    
    Meteor.setTimeout( ->
      weeklyEvents.forEach (event, i) ->
        Meteor.setTimeout( ->
          Meteor.call 'convertToAthleteEventStatsNFL', event.api.SDGameId
        , waitStandard * i)
    , waitA)

    # STEP 3: 
    #
    Meteor.setTimeout( ->
      weeklyEvents.forEach (event, i) ->
        Meteor.setTimeout( ->
          console.log 'batchAthleteEventScoringNFL------', i
          Meteor.call 'batchAthleteEventScoringNFL', event.api.SDGameId
        , waitStandard * i)
    , waitA + waitB)

    # STEP 4: 
    #
    Meteor.setTimeout( ->
      weeklyEvents.forEach (event, i) ->
        Meteor.setTimeout( ->
          console.log 'addScoreByGame-----------------', i
          Meteor.call 'addScoreByGame', 'NFL', event.api.SDGameId
        , waitAPI * i)
    , waitA + waitB + waitA)

    # STEP 5: 
    #
    Meteor.setTimeout( ->
      weeklyEvents.forEach (event, i) ->
        Meteor.setTimeout( ->
          console.log 'addTotalScoreAllEntries---------------', i
          Meteor.call 'addTotalScoreAllEntries', event.api.SDGameId
        , waitAPI * i)
    , waitA + waitB + waitA + waitA)

    # STEP 6: Ranking Entries in the Contest by Top Score
    #
    Meteor.setTimeout( ->
      weeklyEvents.forEach (event, i) ->
        Meteor.setTimeout( ->
          console.log 'rankContestsForEvent---------------', i
          Meteor.call 'rankContestsForEvent', event.api.SDGameId
        , waitStandard * i)
    , waitA + waitB + waitA + waitA + waitA)


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