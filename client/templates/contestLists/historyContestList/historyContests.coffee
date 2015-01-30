Template.historyContestListContainer.helpers

  historyEntriesCount : ->
    Entries.find({ userId: Meteor.userId() }).count()

  historyContests: ->
    Entries.find({ userId: Meteor.userId() })
