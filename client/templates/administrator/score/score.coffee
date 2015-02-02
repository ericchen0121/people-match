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
		Meteor.call 'getEventStats', 'NFL', 4, 'NE', 'SEA' # TODO: change this to be extensible

	'click .create-athlete-event-stats': (e) ->
		event = @
		Meteor.call 'convertSDContestStatToAthleteEventStats', event.api.SDGameId

	'click .score-stats': (e) ->
		event = @
		Meteor.call 'batchAthleteEventScoring', event.api.SDGameId
		Meteor.call 'addScoring', event.api.SDGameId

	'click .score-entries': (e) ->
		event = @
		Meteor.call 'addTotalScoreAllEntries', event.api.SDGameId
