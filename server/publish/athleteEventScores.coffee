Meteor.publish 'athleteEventScoresOnEntry', (entryId) ->

	# find the scores from the athlete 
	entry = Entries.findOne({ _id: entryId })
	console.log 
	# BEWARE: If publish function has incorrect $in array or non-existent Mongo query, things will break
	# For example, if Entry does not have api.SDPlayerIds, the entire app server will 
	# require a restart!
	# https://github.com/meteor/meteor/issues/1633
	# https://groups.google.com/forum/#!msg/meteor-talk/dnnEseBCCiE/l_LHsw-XAWsJ
	return AthleteEventScores.find({
			"api.SDPlayerId": { $in: entry.api.SDPlayerIds },
			"api.SDGameId": { $in: entry.api.SDGameIds }
	})