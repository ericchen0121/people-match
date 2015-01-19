Template.liveContestListContainer.helpers

  liveEntriesCount : ->
    Entries.find({ status: 'inprogress' }).count()

  liveContests: ->
    Entries.find({ status: 'inprogress' })
