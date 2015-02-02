Template.liveContestListContainer.helpers

  liveEntriesCount : ->
    Entries.find({ userId: Meteor.userId(), status: {$in: ['inprogress', 'complete'] }).count()

  liveContests: ->
    Entries.find({ userId: Meteor.userId(), status: {$in: ['inprogress', 'complete'] })
