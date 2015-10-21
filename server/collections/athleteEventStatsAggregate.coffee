# THIS IS A TRIAL TO GET AN AGGREGATE MONGODB PIPELINE TO
# TRANSFORM DATA FROM EVENTSTATS to ATHLETEEVENTSTATS
# As of 1/18/2015, this is not being used and this is a POC
# 
# NOTE: Because Mongo 2.4 is used instead of 2.6, $out and $cond Aggregate
# functions are not available
# 
# TODO: $match criteria will change to something like `status: 'inprogress'`
# eventStatToAthleteEventStat = [
# 	{$match: {api:{SDGameId: "3c42f4ea-e4b3-449d-82d5-36850144add9"}}}, 
# 	{$project: {status: 1, home: 1, team:1}}, 
# 	{$unwind: '$team'}, 
# 	{$project: {team: {rushing: 1}}},
# 	{$unwind: '$team.rushing.player'},
# 	{$project: {team: {rushing: {player: 1}}}}
# ]


# eventStatToAthleteEventStat2 = [
# 	{$match: {api:{SDGameId: "3c42f4ea-e4b3-449d-82d5-36850144add9"}}}, 
# 	{$project: {status: 1, home: 1, team:1}}, 
# 	{$unwind: '$team'}, 
# 	{$project: {team: {kickoffs: 1}}},
# 	{$group: {
# 			_id: 'kickoffs',
# 			statPlayers: {$addToSet: '$team.kickoffs.player'}
# 		}
# 	},
# 	{$unwind: '$statPlayers'},
# 	{$project: {team: {kickoffs: {player: 1}}}}
# ]

# # LEARNINGS, FOR LATER: 
# # can only use $unwind when there is an array.
# # You can check if there is an array by using $ifnull and checking BSON types
# # you can use $group to put things in an array, however the problem with this dataset
# # arises because of $player of each stat is either an object or an array, depending 
# # TO SOLVE this problme, just make every one an array.
# # results = EventStats.aggregate(eventStatToAthleteEventStat)

# Entries.findOne({ _id: "pzfPTTEb6AW9cnp7q" })
# entryScoring = [
# 	{$match: { _id: "pzfPTTEb6AW9cnp7q" }}, 

# ]

# ["e3181493-6a2a-4e95-aa6f-3fc1ddeb7512", "99c4968c-f811-4343-8cba-4bdd2884d734", "600ae879-d95a-4ac4-ae4e-72c05a05f1ad", "2bb70d56-a79a-4fa1-ae37-99858a3ffd55", "5707d2b0-ea9e-4a5e-8289-9d52197301d9", "23d7cd82-d526-4fd8-8f8a-97885f2bc926", "cc745cc3-d52a-454b-98c8-ac9155a9405c", "b8426cea-f8b9-4061-8d56-e70d1230103e", "2142a164-48ad-47d6-bb27-0bc58c6b2e62", "a527b7db-0b52-4379-9e4c-2e08c1fe1bed" ]

# Entries.aggregate

# result = AthleteEventScores.aggregate([
#     { $match: {'api.SDPlayerId': { $in: [ "64797df2-efd3-4b27-86ee-1d48f7edb09f", "6eba2319-7d5b-44da-bc48-280d3f9e423f", "5e5c57a2-f141-4fd7-848d-ea48e8d96a6e", "a69419b7-3cdc-48b9-b3a3-c50f2bf4e6f1", "ffec1b11-6b1b-482d-86f0-3bf4f6391dbf", "3058b3c8-0fa3-4bd4-9df9-6a56a7b4af88", "988d1e04-588f-405e-968a-08813d019a72", "e5247e5f-c4af-4a9b-8c7c-da75ef7fbf8d", "BAL" ] }, 'api.SDGameId': { $in: [ "c7c45e93-5d60-4389-84e1-971c8ce8807e", "83fab116-f034-4f9a-b769-c4e461466a72" ]}}},
#     { $group: { _id: null, totalScore: { $sum: '$score' } }}
# ])

# console.log 'AGGREGATE FUNCTION TESTING ----------------------------', result

# db.athleteEventScores.aggregate(
#     {$match: {'api.SDPlayerId': { $in: [ "64797df2-efd3-4b27-86ee-1d48f7edb09f", "6eba2319-7d5b-44da-bc48-280d3f9e423f"]} }}, 
#     { $group: { _id: null, totalScore: { $sum: '$score' } }})