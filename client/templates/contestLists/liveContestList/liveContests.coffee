Template.liveContestListContainer.helpers

  liveEntriesCount : ->
    Entries.find({ userId: Meteor.userId(), status: 'inprogress' }).count()

  liveContests: ->
    Entries.find({ userId: Meteor.userId(), status: 'inprogress' })
