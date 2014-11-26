# Meteor.publish 'nflSuperstars', ->
#   console.log @userId
#   console.log NflSuperstars.find({ userId: @userId })
#   # Meteor.userId can only be invoked in method calls. Use this.userId in publish functions.
#   NflSuperstars.find({ userId: @userId })

# This sets up a reactive join on superstars and nflPlayers
# https://atmospherejs.com/reywood/publish-composite
#
Meteor.publishComposite('nflSuperstars', {
  # This is the top level collection, finding all the superstar documents
  find: ->
     # @userId will find the current user's id on the server method
    return NflSuperstars.find({ userId: @userId })

  # children is an array of object literals with more finds
  # argument is the first top level collection, must return a cursor
  children: [{
    find: (superstar) ->
      return NflPlayers.find(superstar.nflPlayerId)
  }]
})
