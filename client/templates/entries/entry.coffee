Template.entryView.helpers

	# Returns the score
	score : ->
		athlete = @ # via template data context
		if athlete.api # in case athlete doesn't have api (TO DEPRECATEs)
			# TODO: Limit it to the games to ensure right score
			# however, need parent context... "api.SDGameId: {$in: [ @.api.SDGameIds ]
			scoreDoc = AthleteEventScores.findOne(
				{ "api.SDPlayerId": athlete.api.SDPlayerId}
			)
			if scoreDoc then scoreDoc.score / 100.0 else 0
		else 
			return 0 
		
	# returns 88.55 from a score of 8855
	formatScore: (score) ->
		score / 100.0 
	
	# returns 88 from a score of 8855
	pointScore: (score) ->
		return Math.floor(score / 100)

	# returns 55 from a score of 8855
	decimalScore: (score) ->
		return (score - ( Math.floor(score / 100) * 100) )

	# This outputs an Array of objects consisting of relevant stats
	# I considered storing this on the AthleteEventScores object itself, however 
	# I like more flexibility into the 'presentation' and the naming of stats.
	# 
	relevantStats: ->
		athlete = @
		relevantStats = []

		if athlete.api 
			scoreDoc = AthleteEventScores.findOne({ "api.SDPlayerId": athlete.api.SDPlayerId } )

		if scoreDoc
			for stat in scoreDoc.allStats
				switch stat.statType
					when 'passing'
						relevantStats.push({ type: 'yds', value: stat.stats.yds })
						relevantStats.push({ type: 'TDs', value: stat.stats.td }) 
						relevantStats.push({ type: 'INTs', value: stat.stats.int }) 
					when 'rushing'
						relevantStats.push({ type: 'ruYds', value: stat.stats.yds })
						relevantStats.push({ type: 'ruTDs', value: stat.stats.td })
					when 'receiving'
						relevantStats.push({ type: 'rec', value: stat.stats.rec })
						relevantStats.push({ type: 'tar', value: stat.stats.tar })
						relevantStats.push({ type: 'recYds', value: stat.stats.yds })
						relevantStats.push({ type: 'recTDs', value: stat.stats.td })
					when 'touchdowns'
						if stat.stats.int != 0 then relevantStats.push({ type: 'intTD', value: stat.stats.int })
						if stat.stats.fum_ret != 0 then relevantStats.push({ type: 'fumRetTD', value: stat.stats.fum_ret })
						if stat.stats.punt_ret != 0 then relevantStats.push({ type: 'puntRetTD', value: stat.stats.punt_ret })
						if stat.stats.kick_ret != 0 then relevantStats.push({ type: 'kickRetTD', value: stat.stats.kick_ret })
						if stat.stats.fg_ret != 0 then relevantStats.push({ type: 'fgRetTD', value: stat.stats.fg_ret })
					when 'fumbles'
						if stat.stats.lost != 0 then relevantStats.push({ type: 'fumbles', value: stat.stats.lost })
					when 'field_goal'
						relevantStats.push({ type: 'fg', value: stat.stats.made })
						relevantStats.push({ type: 'att', value: stat.stats.att })
						relevantStats.push({ type: '40+ yds', value: stat.stats.made_49 })
						relevantStats.push({ type: '50+ yds', value: stat.stats.made_50 })
					when 'extra_point'
						relevantStats.push({ type: 'extra pts', value: stat.stats.made })
					when 'defense'
						relevantStats.push({ type: 'sack', value: stat.stats.sack })
						relevantStats.push({ type: 'fumble rec', value: stat.stats.fum_rec })
						relevantStats.push({ type: 'int', value: stat.stats.int })
						relevantStats.push({ type: 'int TD', value: stat.stats.int_td })
						relevantStats.push({ type: 'fumble TD', value: stat.stats.fum_td })

		console.log relevantStats

		return relevantStats