Meteor.methods
	
	# Takes One Game 
	# 1. Gets the athletes stats associated
	# 2. Gets aggregated stats through pipeline
	# 3. Stores them in a new AthleteEventScore Collection!
	# 
	batchAthleteEventScoring: (sdGameId) ->
		# get distinct ids per game
		SDathleteIds = Meteor.call '_getAthletes', sdGameId

		# gets aggregated stats per athlete per event
		aggregatedStats = []
		for id in SDathleteIds
			aggregatedStats.push (Meteor.call '_getAggregateStats', id, sdGameId)

		# pushes them into a new Collection
		for newStat in aggregatedStats
			AthleteEventScores.upsert(
				{
					"api.compoundId": newStat.api.compoundId
				}, 
				_.omit(newStat, '_id')
			)

	# Returns all unique athletes per Game
	# input is SportsData API Game Id 
	# output is an [Array] of Sports Data Player Ids
	_getAthletes: (sdGameId) ->
		return AthleteEventStats.distinct( 'api.SDPlayerId', {'api.SDGameId': sdGameId } )

	# Returns the transformed document to insert 
	# from mongo's aggregation pipeline
	_getAggregateStats: (sdPlayerId, sdGameId) ->
		# TODO: IF this fails when there isn't yet a SCORE field... conditional if `score` field exists
		# then may need to copy this and do a check if they field exitsts....
		stats =  AthleteEventStats.aggregate([ 
			{ $match: { "api.SDPlayerId": sdPlayerId, "api.SDGameId": sdGameId } },
		 	{ $project: { _id: 0, "api.SDPlayerId": "$api.SDPlayerId", "api.SDGameId": "$api.SDGameId", "api.compoundId": {$concat: ["$api.SDPlayerId", "-", "$api.SDGameId"]}, status: 1, sport: 1, teamId: 1, "stats.statType": "$statType", "stats.stats": "$stats", full_name: 1, position: 1, score: 1 }}, 
		 	{ $group: { _id: null, allStats: {$addToSet: "$stats"}, api: {$first: "$api"}, status: {$first: "$status"}, sport: {$first: "$sport"}, teamId: {$first: "$teamId"}, full_name: {$first: "$full_name"}, position: {$first: "$position"}, score: {$first: "$score"} } }
		])

		return stats[0]
		
	# Add scores to each AthleteEventScore
	# Note: scores are multiplied by 100, to keep good javascript integers for the scores
	# TODO: add a dictionary of statType variables, for easy switching out of scoring styles...
	# ie: points = { rushing_yds = .1, ... }
	addScoring: ->
		# TODO: currently this finds all scores docs and processes them all
		# Will want to filter them down to process a reasonable amount at a time 
		# TODO: How to do this stuff really reactively?
		AthleteEventScores.find().forEach (doc) ->
			score = 0 # initialize scores
			for stat in doc.allStats
				switch stat.statType
					when 'rushing'
						score += stat.stats.yds * 10
					when 'passing'
						score += stat.stats.yds * 4
						score += stat.stats.td * 400
						score += stat.stats.int * -100
					when 'receiving'
						score += stat.stats.yds * 10
						score += stat.stats.rec * 50
					when 'touchdowns'
						score += stat.stats.pass * 600
						score += stat.stats.rush * 600
						score += stat.stats.int * 600 
						score += stat.stats.fum_ret * 600
						score += stat.stats.punt_ret * 600
						score += stat.stats.kick_ret * 600
						score += stat.stats.fg_ret * 600
						score += stat.stats.other * 600
					# when 'two_point_conversion'
						# score += stat.stats. # TODO: Add when you know the key
					when 'fumbles'
						score += stat.stats.lost * -200
						score += stat.stats.own_rec_td * 600
					when 'field_goal'
						score += stat.stats.made_19 * 300
						score += stat.stats.made_29 * 300
						score += stat.stats.made_39 * 300
						score += stat.stats.made_49 * 400
						score += stat.stats.made_50 * 500
					when 'extra_point'
						score += stat.stats.made * 100
					when 'defense' # DOUBLE CHECK THESE CATEGORIES ARE ALL COVERED
						score += stat.stats.sack * 100
						score += stat.stats.fum_rec * 200
						score += stat.stats.int * 200
						score += stat.stats.int_td * 600
						score += stat.stats.fum_td * 600

			AthleteEventScores.update(
				{ _id: doc._id } # update its own doc
				{ $set: { score: score }}
			)

# j
# Meteor.call 'batchAthleteEventScoring', '6d1d2061-0130-4a79-b772-4297bc0e3e92'

# Meteor.call 'batchAthleteEventScoring', "e659d606-7755-4fe6-a6f9-2c7da29da194"
# Meteor.call 'addScoring'