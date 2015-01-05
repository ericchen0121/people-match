Template.historyContestListContainer.helpers

  historyEntriesCount : ->
    Entries.find().count()

  historyContests: ->
    Entries.find()
