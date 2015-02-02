Template.historyContestListContainer.helpers

  historyEntriesCount : ->
    Entries.find({ userId: Meteor.userId(), status: {$in: ['complete', 'closed']} }).count()

  historyContests: ->
    Entries.find({ userId: Meteor.userId(), status: {$in: ['complete', 'closed']} })
