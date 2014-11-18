Meteor.publish 'userData', -> 
	if @userId
		return Meteor.users.find(
			{_id: @.userId}, 
			{fields: {'services': 1}}
		)
	else 
		@ready()