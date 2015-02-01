Template.score.helpers

	# TODO: Run a CRON job once a day, or multiple times a day, to constantly get new events into the system
	# with new status.
	# find events that are upcoming ie. `created`, or live, ie. `inprogress`
	# these are states given bt the SD API.
	# 
	liveEvents:  ->
		Events.find({ status: {$in: ['inprogress', 'created']} })

Template.score.events
	# TODO: un-hardcode this.
	'click .update-events': (e) ->
		console.log 'udpate or get event status'
		Meteor.call 'getEvents', 'NFL', 4

	# TODO: un-hardcode this.
	'click .update-event-stats': (e) ->
		console.log 'udpate event stats'
		Meteor.call 'getEventStats', 'NFL', 4, 'NE', 'SEA' # TODO: change this to be extensible

	'click .create-athlete-event-stats': (e) ->
		# NOTE: @ is the event object, uniquely ID'ed by api.SDGameID attribute
		Meteor.call 'convertSDContestStatToAthleteEventStats', {api: {SDGameId: @.api.SDGameId }}

	'click .score-stats': (e) ->
		console.log 'udpate event stats'
		Meteor.call 'batchAthleteEventScoring', 'cbe05cd0-21ae-4740-92e0-8550039a7f16'
		Meteor.call 'addScoring'