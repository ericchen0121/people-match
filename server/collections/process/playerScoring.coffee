# VERSION 1
# playerScoring = 
# [ 
# 	{ $match: { "api.SDPlayerId": "99c4968c-f811-4343-8cba-4bdd2884d734", "api.SDGameId": "6d1d2061-0130-4a79-b772-4297bc0e3e92" } },
#  	{ $project: { _id: 0, api: 1, status: 1, sport: 1, teamId: 1, "stats.statType": "$statType", "stats.stats": "$stats", full_name: 1, position: 1}}, 
#  	{ $group: { _id: null, allStats: {$addToSet: "$stats"}, api: {$first: "$api"}, status: {$first: "$status"}, sport: {$first: "$sport"}, teamId: {$first: "$teamId"}, full_name: {$first: "$full_name"}, position: {$first: "$position"}} } 
# ]
 
# athleteStat = AthleteEventStats.aggregate( playerScoring )[0]

# AthleteEventScore.insert(athleteStat)


# Finds unique athletes per Game
findUniqueAthleteIds = (sdGameId) ->
	console.log AthleteEventStats.distinct( 'api.SDPlayerId' )

athleteEventScoring = (sdPlayerId, sdGameId) ->
	stats =  AthleteEventStats.aggregate([ 
		{ $match: { "api.SDPlayerId": sdPlayerId, "api.SDGameId": sdGameId } },
	 	{ $project: { _id: 0, api: 1, status: 1, sport: 1, teamId: 1, "stats.statType": "$statType", "stats.stats": "$stats", full_name: 1, position: 1 }}, 
	 	{ $group: { _id: null, allStats: {$addToSet: "$stats"}, api: {$first: "$api"}, status: {$first: "$status"}, sport: {$first: "$sport"}, teamId: {$first: "$teamId"}, full_name: {$first: "$full_name"}, position: {$first: "$position"}} } 
	])
	console.log stats[0]

batchAthleteEventScoring = (sdGameId) ->
	athleteIds = findUniqueAthleteIds(sdGameId)
	for id in athleteIds
		athleteEventScoring(id, sdGameId)

# athleteEventScoring("99c4968c-f811-4343-8cba-4bdd2884d734", "6d1d2061-0130-4a79-b772-4297bc0e3e92")
findUniqueAthleteIds('6d1d2061-0130-4a79-b772-4297bc0e3e92')
# batchAthleteEventScoring('6d1d2061-0130-4a79-b772-4297bc0e3e92')

# VERSION 2
# matchScoring = 
# [ 
# 	{ $match: { "api.SDGameId": "6d1d2061-0130-4a79-b772-4297bc0e3e92" } },
# 	{ $group: {_id: "$api.SDPlayerId"}},
#  	{ $project: { _id: 0, api: 1, status: 1, sport: 1, teamId: 1, "stats.statType": "$statType", "stats.stats": "$stats", full_name: 1, position: 1}}, 
#  	{ $group: { _id: null, allStats: {$addToSet: "$stats"}, api: {$first: "$api"}, status: {$first: "$status"}, sport: {$first: "$sport"}, teamId: {$first: "$teamId"}, full_name: {$first: "$full_name"}, position: {$first: "$position"}} } 
# ]

# athleteStat = AthleteEventStats.aggregate( matchScoring )[0]

# console.log athleteStat
# AthleteEventScore.insert(athleteStat)

# FOR METEOR MONGO QUERY
# db.athleteEventStats.aggregate([ 
# 	{ $match: { "api.SDGameId": "6d1d2061-0130-4a79-b772-4297bc0e3e92" } },
# 	{ $group: {_id: "$api.SDPlayerId"}},
#  	{ $project: { _id: 0, api: 1, status: 1, sport: 1, teamId: 1, "stats.statType": "$statType", "stats.stats": "$stats", full_name: 1, position: 1}}, 
#  	{ $group: { _id: null, allStats: {$addToSet: "$stats"}, api: {$first: "$api"}, status: {$first: "$status"}, sport: {$first: "$sport"}, teamId: {$first: "$teamId"}, full_name: {$first: "$full_name"}, position: {$first: "$position"}} } 
# ])