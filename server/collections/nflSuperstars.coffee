Meteor.methods
  
  # This server method is called from the client to add players to your "favorites" list
  # A superstar is an nflPlayer starred by a user
  # Technically, a superstar is a 'join table' of a nflPlayerId and userId
  #
  superstarInsert: (superstarAttributes)->
    console.log 'superstarInsert method...'

    # get the logged in user
    user = Meteor.user()

    # extend it with a few properties
    superstar = _.extend(superstarAttributes, {
      userId: user._id
      createdAt: new Date()
    })

    # check if already exists with same nflPlayer and user
    superstarOriginal = NflSuperstars.findOne({
      nflPlayerId: superstar.nflPlayerId,
      userId: superstar.userId
    })

    # if Original copy exists, short circuit return before inserting to db
    return { superstarExists: true, _id: superstarOriginal._id} if superstarOriginal

    # else create a new superstar in the db!!!
    NflSuperstars.insert(superstar)
