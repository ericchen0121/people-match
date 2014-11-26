Template.avatarImage.helpers

    user: ->
      Meteor.user()

    profileName: ->
      Meteor.user().profile.name

Template.fourOhFour.helpers

	wackoForFlacco: () ->
		# Flacco's espn_id is 11252
		player = NflPlayers.findOne({espn_id: 11252})
		
		player.first_name = 'Wacko For'
		player.position = 'Looks like you be lost'
		player.jersey_number = 404

		return player
