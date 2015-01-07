#CONVERT AN EVENT STAT INTO AN ATHLETE EVENT STAT
# This method currently finds the BAL vs PIT 2014_PST_1 game
# and converts it into atheleteStatEvents
# this is a POC
# 
Meteor.methods

	convertContestStatToAthleteEventStats: ->

		eventStat = EventStats.findOne({_id: "CvqPgB7oboD7m62v7"}) # TO PASS IN AS AN ARGUMENT
		newStat = {}

		newStat.api = eventStat.api # API id for event
		newStat.status = eventStat.status
		newStat.sport = 'NFL'
		newStat.stats = {}
		# TODO: add game id: '2014_PST_1_BAL_PIT'

		# for each of the two teams in the array
		# POTENTIALLY ADD EVENT ID
		#
		for team in eventStat.team
			newStat.teamId = team.id

			for rushingStat in team.rushing.player
				newStat.api.SDPlayerId = rushingStat.id
				newStat.full_name = rushingStat.name
				newStat.position = rushingStat.position
				newStat.stats = rushingStat
				newStat.stats.type = 'rushing' 
				AthleteEventStats.insert(newStat)

			for passingStat in team.passing.player
				newStat.api.SDPlayerId = passingStat.id
				newStat.full_name = passingStat.name
				newStat.position = passingStat.position
				newStat.stats = passingStat
				newStat.stats.type = 'passing'
				AthleteEventStats.insert(newStat)

			for receivingStat in team.receiving.player
				newStat.api.SDPlayerId = receivingStat.id
				newStat.full_name = receivingStat.name
				newStat.position = receivingStat.position
				newStat.stats = receivingStat
				newStat.stats.type = 'receiving'
				AthleteEventStats.insert(newStat)

			# for any punt or kickoff return touchdowns
			for touchdownStat in team.touchdowns.player
				newStat.api.SDPlayerId = touchdownStat.id
				newStat.full_name = touchdownStat.name
				newStat.position = touchdownStat.position
				newStat.stats = touchdownStat
				newStat.stats.type = 'touchdown'
				AthleteEventStats.insert(newStat)

			if team.two_point_conversion
				for twoPtStat in team.two_point_conversion.player
					newStat.api.SDPlayerId = twoPtStat.id
					newStat.full_name = twoPtStat.name
					newStat.position = twoPtStat.position
					newStat.stats = twoPtStat
					newStat.stats.type = 'twoPoint'
					AthleteEventStats.insert(newStat)

			if team.fumbles
				for fumbleStat in team.fumbles.player
					newStat.api.SDPlayerId = fumbleStat.id
					newStat.full_name = fumbleStat.name
					newStat.position = fumbleStat.position
					newStat.stats = fumbleStat
					newStat.stats.type = 'fumbles'
					AthleteEventStats.insert(newStat)

			for fieldGoalStat in team.field_goal.player
				newStat.api.SDPlayerId = fieldGoalStat.id
				newStat.full_name = fieldGoalStat.name
				newStat.position = fieldGoalStat.position
				newStat.stats = fieldGoalStat
				newStat.stats.type = 'fieldGoal'
				AthleteEventStats.insert(newStat)

			# DEFENSE Stat
			newStat.api.SDPlayerId = undefined
			newStat.api.SDTeamId = team.id 
			newStat.stats = _.omit(team.defense, 'player') # remove player array
			newStat.stats.type = 'defense'
			AthleteEventStats.insert(newStat)

# Meteor.call 'convertContestStatToAthleteEventStats'

