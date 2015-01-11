# ARUNODA WAS HERE
# NflSuperstars.before.insert (userId, doc) ->
#   doc.createdAt = Date.now()
#   doc.userId = userId

Meteor.methods

  # This server method is called from the client to add players to your "favorites" list
  # A superstar is an nflPlayer starred by a user
  # Technically, a superstar is a 'join table' of a nflPlayerId and userId
  #
  superstarInsert: (superstar) ->

    # check if the superstar object already exists with same nflPlayer and user
    superstarAlreadyInDB = NflSuperstars.findOne({
      nflPlayerId: superstar.nflPlayerId,
      userId: Meteor.userId
    })

    # if Original copy exists, short circuit return before inserting to db
    # client can check if superstarExists and we also return the id of the original one if necessary
    return { superstarExists: true, superstarId: superstar._id } if superstarAlreadyInDB
    # this error is not caught properly on the client side code right now. in nflPlayersListCards.coffee

    console.log 'superstarInsert ...'

    # else create a new superstar in the db!!!
    NflSuperstars.insert(superstar)
