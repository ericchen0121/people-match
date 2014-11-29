# This sets up a reactive join on superstars and nflPlayers
# https://atmospherejs.com/reywood/publish-composite
#
Meteor.publishComposite('nflSuperstars', {
  # This is the top level collection, find these first, then create the join...
  find: ->
    # @userId will find the current user's id on the server 
    # http://stackoverflow.com/questions/16532316/how-to-get-meteor-user-to-return-on-the-server-side
    # 
    return NflSuperstars.find({ userId: @userId })

  # This is how you join, thru children/find
  # children is an array of object literals with more finds
  # argument is the first top level collection, must return a cursor
  children: [{
    find: (superstar) ->
      return NflPlayers.find(superstar.nflPlayerId)
  }]
})
