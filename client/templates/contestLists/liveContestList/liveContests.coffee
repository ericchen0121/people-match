Template.liveContestListContainer.helpers

  liveEntriesCount : ->
    Entries.find({ userId: Meteor.userId(), status: {$in: ['inprogress', 'complete']}, contestStarts: mq.today }).count()

  liveContests: ->
    Entries.find({ userId: Meteor.userId(), status: {$in: ['inprogress', 'complete']}, contestStarts: mq.today })
