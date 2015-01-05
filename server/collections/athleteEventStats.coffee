#CONVERT AN EVENT STAT INTO AN ATHLETE EVENT STAT
Meteor.methods

	retrieveContestStat: ->

		eventStat = EventStats.findOne({_id: "CvqPgB7oboD7m62v7"})
		console.log 'HELLO WE ARE IN THIS METHOD, in athleteEventStats'
		console.log eventStat
		console.log eventStat.team
		newStat = {}

		newStat.api = eventStat.api # API id for event
		for team in eventStat.team
			newStat.teamId = team.id # 'BAL'
			newStat.stats = {

			}

		AthleteEventStats.insert({
			api: {
					SDGameID: eventStat.api.SDGameID
				}
			athleteId: 
			eventId: 
			teamId: 
			stats: 
				{

				}
			createdAt: 
			updatedAt: 
		})
		

# Meteor.call 'retrieveContestStat'

