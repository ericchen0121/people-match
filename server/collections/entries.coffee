# Collection-hooks adds attributes before Entries.insert(entry)
# ARUNODA WAS HERE
# Entries.before.insert (userId, doc) ->
#   doc.createdAt = Date.now()
#   doc.updatedAt = Date.now()
#   doc.userId = userId

#   # adds array of event api ids to the Entry
#   contest = Contests.findOne({_id: doc.contestId})
#   doc.api ?= {}
#   eventIds = (id for {api: {SDGameId: id}} in contest.fixture.events)
#   doc.api.SDGameIds = eventIds

Meteor.methods
  entryCreate: (entry) ->
    # update the contest with the number of entries
    Contests.update(entry.contestId, {$inc: {entryCount: 1 }})
    Entries.insert(entry)
