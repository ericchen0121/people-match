Template.historyContestListContainer.helpers

  historyEntriesCount : ->
    Entries.find({ status: 'history' }).count()

  historyContests: ->
    Entries.find({ status: 'history' })
