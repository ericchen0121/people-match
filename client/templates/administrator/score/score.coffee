Template.score.helpers

	liveEvents:  ->
		Events.find({ status: 'inprogress' })

Template.score.events
	# TODO: un-hardcode this.
	'click .update-events': (e) ->
		console.log 'udpate or get event status'
		Meteor.call 'getEvents', 'NFL', 4

	# TODO: un-hardcode this.
	'click .update-event-stats': (e) ->
		console.log 'udpate event stats'
		Meteor.call 'getEventStats', 'NFL', 4, 'SEA', 'NE'

	'click .create-athlete-event-stats': (e) ->
		console.log 'convert to athlete event stats'
		Meteor.call 'convertSDContestStatToAthleteEventStats', 'RYHL4Sn2jMKjQW9zb'

	'click .score-stats': (e) ->
		console.log 'udpate event stats'
		Meteor.call 'batchAthleteEventScoring', 'cbe05cd0-21ae-4740-92e0-8550039a7f16'
		Meteor.call 'addScoring'