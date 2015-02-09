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
    Events.find({ status: {$in: ['inprogress', 'created', 'complete', 'closed']} })

Template.score.events
  # TODO: un-hardcode this.
  'click .update-events': (e) ->
    Meteor.call 'getEvents', 'NFL', 4 # TODO: Change this so its not hardcoded

  # TODO: un-hardcode this.
  # Base this on a call to WEEKLY or DAILY Schedule thru API. 
  'click .update-event-stats': (e) ->
    event = @
    sport = event.sport

    switch sport
      when 'nfl' #change all event Sport attrs to "NFL"
        Meteor.call 'getEventStatsNFL', 'NFL', 4, event.away, event.home # TODO: change this to be extensible
      when 'NBA'
        Meteor.call 'getEventStatNBA', event.api.SDGameId 

  'click .create-athlete-event-stats': (e) ->
    event = @
    sport = event.sport

    switch sport
      when 'nfl'
        Meteor.call 'convertSDContestStatToAthleteEventStats', event.api.SDGameId
      when 'NBA'
        console.log 'CREATING ATHELETE EVENT STATS in NBA'
        Meteor.call 'convertToAthleteEventStatsNBA', event.api.SDGameId

  'click .score-stats': (e) ->
    event = @
    Meteor.call 'batchAthleteEventScoring', event.api.SDGameId
    Meteor.call 'addScoring', event.api.SDGameId

  'click .score-entries': (e) ->
    event = @
    Meteor.call 'addTotalScoreAllEntries', event.api.SDGameId

  'click .rank-entries': (e) ->
    event = @
    Meteor.call 'rankContestsForEvent', event.api.SDGameId