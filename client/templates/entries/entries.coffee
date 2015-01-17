Template.entryView.helpers

	# Returns the score
	score : ->
		athlete = @
		if athlete.api # in case athlete doesn't have api (TO DEPRECATEs)
			# TODO: Limit it to the games to ensure right score
			# howver, need parent context... "api.SDGameId: {$in: [ @.api.SDGameIds ]
			scoreDoc = AthleteEventScores.findOne(
				{ "api.SDPlayerId": athlete.api.SDPlayerId}
			)
			if scoreDoc then scoreDoc.score / 100.0 else 0
		else 
			return 0 
		