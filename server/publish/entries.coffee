Meteor.publish 'entries', ->
	# Publish only entries of the user
  Entries.find({ userId: this.userId })

Meteor.publish 'entry', (id) ->
	Entries.findOne({ userId: this.userId, _id: id })	