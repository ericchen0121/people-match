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
			statTypes = ['rushing', 'passing', 'receiving', 'touchdowns', 'two_point_conversion', 'extra_point', 'fumbles', 'field_goal']

			for statType in statTypes
				if team[statType] # if it exists... in the middle of a game it may not exist
					
					playerStats = team[statType]['player']
					# ensure it's an array before iterating over it
					if !Array.isArray(playerStats)
						playerStats = [playerStats]

					# iterate over the array.
					# TODO: Fix the "api.SDGameId" key that is created.
					for stat in playerStats
						newStat.statType = statType 
						newStat.api.SDPlayerId = stat.id
						newStat.full_name = stat.name
						newStat.position = stat.position
						newStat.stats = _.omit(stat, ['id', 'name', 'jersey', 'position']) # remove redundant ID, remove all strings

						# convert xml strings to integers.
						for k,v of newStat.stats
							newStat.stats[k] = parseInt(v)

						newStat.api.compoundId = newStat.api.SDGameId + '-' + newStat.api.SDPlayerId + '-' + statType # unique id
						AthleteEventStats.upsert(
							{ "api.compoundId": newStat.api.compoundId }, 
							newStat
						)

		# DEFENSE is easier to deal with separately.
		for team in eventStat.team
			newStat = {}
			newStat.statType = 'defense'
			newStat.api = eventStat.api # API id for event
			newStat.api.SDPlayerId = team.id
			newStat.teamId = team.id
			newStat.status = eventStat.status
			newStat.sport = 'NFL'
			newStat.stats = {}
			newStat.stats = _.omit(team.defense, 'player') # remove entire player array

			# convert xml strings to integers bam
			for k,v of newStat.stats
				newStat.stats[k] = parseInt(v)

			newStat.api.compoundId = newStat.api.SDGameId + '-' + newStat.api.SDPlayerId + '-' +  newStat.statType
			AthleteEventStats.upsert(
				{ "api.compoundId": newStat.api.compoundId }, 
				newStat
			)
			
# TODO: THIS ID ARGUMENT SHOULD NOT BE HARDCODED
# This method currently finds the IND vs DEN 2014_PST_2 game
Meteor.call 'convertSDContestStatToAthleteEventStats', "6JRmaZP3CZButrHnY"

