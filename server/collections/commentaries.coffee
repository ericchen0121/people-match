# # Collection-hooks adds attributes before insert
Commentaries.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updateAt = Date.now()
  doc.userId = userId

Meteor.methods

  # This server method is called from the client to add a commentary.
  # Technically, a commentary is a comment attached to a UserId
  #
  commentaryInsert: (commentary) ->
    Commentaries.insert(commentary)
