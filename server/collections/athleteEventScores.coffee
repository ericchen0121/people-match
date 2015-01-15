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
		stats =  AthleteEventStats.aggregate([ 
			{ $match: { "api.SDPlayerId": sdPlayerId, "api.SDGameId": sdGameId } },
		 	{ $project: { _id: 0, "api.SDPlayerId": "$api.SDPlayerId", "api.SDGameId": "$api.SDGameId", "api.compoundId": {$concat: ["$api.SDPlayerId", "-", "$api.SDGameId"]}, status: 1, sport: 1, teamId: 1, "stats.statType": "$statType", "stats.stats": "$stats", full_name: 1, position: 1 }}, 
		 	{ $group: { _id: null, allStats: {$addToSet: "$stats"}, api: {$first: "$api"}, status: {$first: "$status"}, sport: {$first: "$sport"}, teamId: {$first: "$teamId"}, full_name: {$first: "$full_name"}, position: {$first: "$position"}} } 
		])

		return stats[0]
		
# athleteEventScoring("99c4968c-f811-4343-8cba-4bdd2884d734", "6d1d2061-0130-4a79-b772-4297bc0e3e92")
# findUniqueAthleteIds('6d1d2061-0130-4a79-b772-4297bc0e3e92')
Meteor.call 'batchAthleteEventScoring', '6d1d2061-0130-4a79-b772-4297bc0e3e92'