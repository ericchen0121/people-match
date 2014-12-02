Meteor.methods

  # This server method is called from the client to add a commentary.
  # Technically, a commentary is a comment attached to a UserId
  #
  commentaryInsert: (commentaryAttributes) ->
    console.log 'commentaryInsert method...'

    # get the logged in user
    user = Meteor.user()

    # extend it with a few properties
    commentary = _.extend(commentaryAttributes, {
      userId: user._id
      createdAt: new Date()
    })

    # insert the comment in the db!!!
    Commentaries.insert(commentary)
