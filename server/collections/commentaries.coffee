Meteor.methods
  
  # This server method is called from the client to add players to your "favorites" list
  # A superstar is an nflPlayer starred by a user
  # Technically, a superstar is a 'join table' of a nflPlayerId and userId
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
