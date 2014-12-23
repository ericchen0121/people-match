# Collection-hooks adds attributes before Entries.insert(entry)
Entries.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updatedAt = Date.now()
  doc.userId = userId

Meteor.methods
  entryCreate: (entry) ->
    # update the contest with the number of entries
    Contests.update(entry.contestId, {$inc: {entryCount: 1 }})
    Entries.insert(entry)
