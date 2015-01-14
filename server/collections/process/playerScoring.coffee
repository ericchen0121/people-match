# Finds unique athletes per Game
findUniqueAthleteIds = (sdGameId) ->
	return AthleteEventStats.distinct( 'api.SDPlayerId', {'api.SDGameId': sdGameId } )

athleteEventScoring = (sdPlayerId, sdGameId) ->
	stats =  AthleteEventStats.aggregate([ 
		{ $match: { "api.SDPlayerId": sdPlayerId, "api.SDGameId": sdGameId } },
	 	{ $project: { _id: 0, api: 1, status: 1, sport: 1, teamId: 1, "stats.statType": "$statType", "stats.stats": "$stats", full_name: 1, position: 1 }}, 
	 	{ $group: { _id: null, allStats: {$addToSet: "$stats"}, api: {$first: "$api"}, status: {$first: "$status"}, sport: {$first: "$sport"}, teamId: {$first: "$teamId"}, full_name: {$first: "$full_name"}, position: {$first: "$position"}} } 
	])

	console.log stats[0] 
	# TODO: add an insert method here 
	# for stat in stats
	# { _id: null,
	#    allStats: [ { statType: 'fumbles', stats: [Object] } ],
	#    api:
	#     { SDGameId: '6d1d2061-0130-4a79-b772-4297bc0e3e92',
	#       SDPlayerId: '0bedbbbe-83b5-4d3e-ab68-717702b0c6b4' },
	#    status: 'closed',
	#    sport: 'NFL',
	#    teamId: 'IND',
	#    full_name: 'Jonathan Newsome',
	#    position: 'OLB' }

batchAthleteEventScoring = (sdGameId) ->
	athleteIds = findUniqueAthleteIds(sdGameId)
	console.log athleteIds
	for id in athleteIds
		athleteEventScoring(id, sdGameId)

# athleteEventScoring("99c4968c-f811-4343-8cba-4bdd2884d734", "6d1d2061-0130-4a79-b772-4297bc0e3e92")
# findUniqueAthleteIds('6d1d2061-0130-4a79-b772-4297bc0e3e92')
batchAthleteEventScoring('6d1d2061-0130-4a79-b772-4297bc0e3e92')

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