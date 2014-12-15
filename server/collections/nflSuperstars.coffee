NflSuperstars.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.userId = userId

Meteor.methods

  # This server method is called from the client to add players to your "favorites" list
  # A superstar is an nflPlayer starred by a user
  # Technically, a superstar is a 'join table' of a nflPlayerId and userId
  #
  superstarInsert: (superstar) ->
    console.log 'superstarInsert ...'

    # check if the superstar object already exists with same nflPlayer and user
    superstarAlreadyInDB = NflSuperstars.findOne({
      nflPlayerId: superstar.nflPlayerId,
      userId: Meteor.userId
    })

    # if Original copy exists, short circuit return before inserting to db
    # client can check if superstarExists and we also return the id of the original one if necessary
    return { superstarExists: true, _id: superstarOriginal._id } if superstarAlreadyInDB

    # else create a new superstar in the db!!!
    NflSuperstars.insert(superstar)
