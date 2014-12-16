Template.upcomingContestListContainer.helpers

  upcomingContests: () ->
    Entries.find({ status: 'upcoming' })
