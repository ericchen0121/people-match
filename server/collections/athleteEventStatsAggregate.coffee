# THIS IS A TRIAL TO GET AN AGGREGATE MONGODB PIPELINE TO
# TRANSFORM DATA FROM EVENTSTATS to ATHLETEEVENTSTATS
# As of 1/18/2015, this is not being used and this is a POC
# 
# NOTE: Because Mongo 2.4 is used instead of 2.6, $out and $cond Aggregate
# functions are not available
# 
# TODO: $match criteria will change to something like `status: 'inprogress'`
eventStatToAthleteEventStat = [
	{$match: {api:{SDGameId: "3c42f4ea-e4b3-449d-82d5-36850144add9"}}}, 
	{$project: {status: 1, home: 1, team:1}}, 
	{$unwind: '$team'}, 
	{$project: {team: {rushing: 1}}},
	{$unwind: '$team.rushing.player'},
	{$project: {team: {rushing: {player: 1}}}}
]


eventStatToAthleteEventStat2 = [
	{$match: {api:{SDGameId: "3c42f4ea-e4b3-449d-82d5-36850144add9"}}}, 
	{$project: {status: 1, home: 1, team:1}}, 
	{$unwind: '$team'}, 
	{$project: {team: {kickoffs: 1}}},
	{$group: {
			_id: 'kickoffs',
			statPlayers: {$addToSet: '$team.kickoffs.player'}
		}
	},
	{$unwind: '$statPlayers'},
	{$project: {team: {kickoffs: {player: 1}}}}
]

# LEARNINGS, FOR LATER: 
# can only use $unwind when there is an array.
# You can check if there is an array by using $ifnull and checking BSON types
# you can use $group to put things in an array, however the problem with this dataset
# arises because of $player of each stat is either an object or an array, depending 
# TO SOLVE this problme, just make every one an array.
# results = EventStats.aggregate(eventStatToAthleteEventStat)