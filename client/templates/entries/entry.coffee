Template.entryView.helpers

	# Returns the score.
	score : ->
		athlete = @ # via template data context
		console.log athlete
		if athlete.api # in case athlete doesn't have api (TO DEPRECATEs)
			# TODO: Limit it to the games to ensure right score
			# however, need parent context... "api.SDGameId: {$in: [ @.api.SDGameIds ]
			scoreDoc = AthleteEventScores.findOne(
				{ 'api.SDPlayerId': athlete.api.SDPlayerId }
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
		athlete = @ # based on template data
		relevantStats = []

		# The Key to match the athlete to the 
		if athlete.api 
			scoreDoc = AthleteEventScores.findOne({ "api.SDPlayerId": athlete.api.SDPlayerId } )

		if scoreDoc
			for stat in scoreDoc.allStats
				switch stat.statType
					when 'passing'
						relevantStats.push({ statType: 'passing', type: 'yds', value: stat.stats.yds })
						relevantStats.push({ statType: 'passing', type: 'TDs', value: stat.stats.td }) 
						relevantStats.push({ statType: 'passing', type: 'INTs', value: stat.stats.int }) 
					when 'rushing'
						relevantStats.push({ statType: 'rushing', type: 'ruYds', value: stat.stats.yds })
						relevantStats.push({ statType: 'rushing', type: 'ruTDs', value: stat.stats.td })
					when 'receiving'
						relevantStats.push({ statType: 'receiving', type: 'rec', recRec: 'true', value: stat.stats.rec })
						relevantStats.push({ statType: 'receiving', type: 'rec', recTar: 'true', value: stat.stats.tar })
						relevantStats.push({ statType: 'receiving', type: 'recYds', value: stat.stats.yds })
						relevantStats.push({ statType: 'receiving', type: 'recTDs', value: stat.stats.td })
					when 'touchdowns'
						if stat.stats.int != 0 then relevantStats.push({ statType: 'touchdowns', type: 'intTD', value: stat.stats.int })
						if stat.stats.fum_ret != 0 then relevantStats.push({ statType: 'touchdowns', type: 'fumRetTD', value: stat.stats.fum_ret })
						if stat.stats.punt_ret != 0 then relevantStats.push({ statType: 'touchdowns', type: 'puntRetTD', value: stat.stats.punt_ret })
						if stat.stats.kick_ret != 0 then relevantStats.push({ statType: 'touchdowns', type: 'kickRetTD', value: stat.stats.kick_ret })
						if stat.stats.fg_ret != 0 then relevantStats.push({ statType: 'touchdowns', type: 'fgRetTD', value: stat.stats.fg_ret })
					when 'fumbles'
						if stat.stats.lost != 0 then relevantStats.push({ statType: 'fumbles', type: 'fumbles', value: stat.stats.lost })
					when 'field_goal'
						relevantStats.push({ statType: 'field_goal', type: 'fg', fgMade: 'true', value: stat.stats.made })
						relevantStats.push({ statType: 'field_goal', type: 'att', fgAtt: 'true', value: stat.stats.att })
						relevantStats.push({ statType: 'field_goal', type: '40+ yds', value: stat.stats.made_49 })
						relevantStats.push({ statType: 'field_goal', type: '50+ yds', value: stat.stats.made_50 })
					when 'extra_point'
						relevantStats.push({ statType: 'extra_point', type: 'extra pts', value: stat.stats.made })
					when 'defense'
						relevantStats.push({ statType: 'defense', type: 'sack', value: stat.stats.sack })
						relevantStats.push({ statType: 'defense', type: 'fumble rec', value: stat.stats.fum_rec })
						relevantStats.push({ statType: 'defense', type: 'int', value: stat.stats.int })
						relevantStats.push({ statType: 'defense', type: 'int TD', value: stat.stats.int_td })
						relevantStats.push({ statType: 'defense', type: 'fumble TD', value: stat.stats.fum_td })

		return relevantStats