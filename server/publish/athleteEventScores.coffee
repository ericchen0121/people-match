Meteor.publish 'athleteEventScoresOnEntry', (entryId) ->

	AtheteEventScores.find({ 
		entry = Entry.findOne({ _id: entryId })
		return AthleteEventScores.find({
				"api.SDPlayerId": { $in: entry.api.SDPlayerIds },
				"api.SDTeamId": { $in: entry.api.SDTeamIds }
		})
	})