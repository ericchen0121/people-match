Template.upcomingContestListContainer.helpers

  upcomingEntriesCount : ->
    Entries.find({ status: 'upcoming' }).count()

  upcomingContests: ->
    Entries.find({ status: 'upcoming' })
