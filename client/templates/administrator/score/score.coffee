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
    Events.find { startsAt: mq.lastFewDays }

Template.score.events
  # TODO: un-hardcode this.
  # NOTE: NBA events are all created at the beginning of the year
  'click .update-events-status': (e) ->
    event = @
    console.log @
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
        Meteor.call 'batchAthleteEventScoringNFL', event.api.SDGameId
        Meteor.call 'addScoreByGame', 'NFL', event.api.SDGameId
      when 'NBA'
        # Previous method already added to AthleteEventScores
        Meteor.call 'addScoreByGame', 'NBA', event.api.SDGameId

  'click .score-entries': (e) ->
    event = @
    Meteor.call 'addTotalScoreAllEntries', event.api.SDGameId

  'click .rank-entries': (e) ->
    event = @
    Meteor.call 'rankContestsForEvent', event.api.SDGameId