# Collection-hooks adds attributes before Entries.insert(entry)
Entries.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updatedAt = Date.now()
  doc.userId = userId

Meteor.methods
  # This server method adds a contest entry
  #
  entryCreate: (entry) ->
    Entries.insert(entry)
