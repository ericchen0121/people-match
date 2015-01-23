# Collection-hooks adds attributes before insert
Commentaries.before.insert (userId, doc) ->
  doc.createdAt = doc.createdAt || new Date().toISOString()
  doc.updatedAt = new Date().toISOString()
  doc.userId = userId

Meteor.methods

  # This server method is called from the client to add a commentary.
  # Technically, a commentary is a comment attached to a UserId
  #
  commentaryInsert: (commentary) ->
    Commentaries.insert(commentary)
