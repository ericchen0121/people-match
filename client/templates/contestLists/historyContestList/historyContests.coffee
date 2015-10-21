Template.historyContestListContainer.helpers

  historyEntriesCount : ->
    # Entries.find({ userId: Meteor.userId(), status: {$in: ['complete', 'closed']} }).count()
    Entries.find({ userId: Meteor.userId()}).count()

  historyContests: ->
    Entries.find({ userId: Meteor.userId(), status: {$in: ['unsure', 'complete', 'closed']} })
	# Entries.find({ userId: Meteor.userId() })
	# console.log Entries.find({ userId: Meteor.userId() }).fetch()