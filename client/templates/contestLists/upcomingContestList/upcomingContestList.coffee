Template.upcomingContestListContainer.helpers

  upcomingEntriesCount : ->
    # TODO: We need to set the status of newly created contests (contestCreate) to 'upcoming'
    # or 'scheduled', or some approved terminology
    # Then we need to ensure the lifecycle of managing this status state. Upon creation,
    # we always name it 'upcoming'. when a contest starts, we update all entries associated
    # with 'live', and when it's over, we name it 'history'. All entries after creation are
    # managed and updated through contests.
    Entries.find({ userId: Meteor.userId(), contestStarts: mq.future }).count() # as long as the entry is in the future

  upcomingContests: ->
    Entries.find({ userId: Meteor.userId(), contestStarts: mq.future })
