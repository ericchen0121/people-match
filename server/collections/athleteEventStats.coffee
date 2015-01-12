# TODO: Rewrite these methods in the aggregate framwork. Examples in athleteEventStats2.coffee. 
# 
Meteor.methods

	convertSDContestStatToAthleteEventStats: (id) ->

		eventStat = EventStats.findOne({_id: id})
		newStat = {}

		newStat.api = eventStat.api # API id for event
		newStat.status = eventStat.status
		newStat.sport = 'NFL'
		newStat.stats = {}
		# TODO: add `game id: '2014_PST_1_BAL_PIT'` in a standard query format for 'easy intuitive querying'

		# parse each of the two teams in the array
		for team in eventStat.team
			newStat.teamId = team.id

			# Create a new AthleteEventStat doc for each player in the EventStat for each 
			# statistical category of relevance
			statTypes = ['rushing', 'passing', 'receiving', 'touchdowns', 'two_point_conversion', 'fumbles', 'field_goal']

			for statType in statTypes
				if team[statType] # if it exists... in the middle of a game it may not exist
					
					playerStats = team[statType]['player']
					# ensure it's an array before iterating over it
					if !Array.isArray(playerStats)
						playerStats = [playerStats]

					# iterate over the array
					for stat in playerStats
						newStat.api.SDPlayerId = stat.id
						newStat.full_name = stat.name
						newStat.position = stat.position
						newStat.stats = _.omit(stat, ['id', 'name', 'jersey', 'position']) # remove redundant ID
						newStat.statType = statType 
						AthleteEventStats.upsert(
							{ "api.SDGameId": newStat.api.SDGameId, "api.SDPlayerId": newStat.api.SDPlayerId, "statType": newStat.statsType }, 
							{ $set: newStat },
							(err, res) -> 
						)
						# AthleteEventStats.insert(newStat)
		# DEFENSE is easier to deal with separately
		for team in eventStat.team
			newStat = {}
			newStat.api = _.omit(eventStat.api, 'SDPlayerId') # API id for event
			newStat.api.SDTeamId = team.id 
			newStat.status = eventStat.status
			newStat.sport = 'NFL'
			newStat.stats = {}
			newStat.stats = _.omit(team.defense, 'player') # remove entire player array
			newStat.statType = 'defense'
			AthleteEventStats.upsert(
				{ "api.SDGameId": newStat.api.SDGameId, "api.SDPlayerId": newStat.api.SDPlayerId, "statType": newStat.statsType }, 
				{ $set: newStat },
				(err, res) -> 
			)
			
# TODO: THIS ID ARGUMENT SHOULD NOT BE HARDCODED
# This method currently finds the IND vs DEN 2014_PST_2 game
Meteor.call 'convertSDContestStatToAthleteEventStats', "6JRmaZP3CZButrHnY"

