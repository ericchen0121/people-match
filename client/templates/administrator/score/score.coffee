Template.score.helpers

	liveEvents:  ->
		Events.find({ status: 'inprogress' })

Template.score.events
	'click .update-events': (e) ->
		console.log 'udpate or get event status'
		Meteor.call 'getEvents', 'NFL', 3

	'click .update-event-stats': (e) ->
		console.log 'udpate event stats'
		Meteor.call 'getEventStats', 'NFL', 3, 'IND', 'NE'

	'click .create-athlete-event-stats': (e) ->
		console.log 'convert to athlete event stats'
		Meteor.call 'convertSDContestStatToAthleteEventStats', 'RYHL4Sn2jMKjQW9zb'

	'click .score-stats': (e) ->
		console.log 'udpate event stats'
		Meteor.call 'batchAthleteEventScoring', 'cbe05cd0-21ae-4740-92e0-8550039a7f16'
		Meteor.call 'addScoring'