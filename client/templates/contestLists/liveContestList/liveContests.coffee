Template.liveContestListContainer.helpers

  liveEntriesCount : ->
    Entries.find({ status: 'live' }).count()

  liveContests: ->
    Entries.find({ status: 'live' })
