Meteor.publish 'nflSuperstars', ->
  console.log @userId
  console.log NflSuperstars.find({userId: @userId })
  # Meteor.userId can only be invoked in method calls. Use this.userId in publish functions.
  NflSuperstars.find({userId: @userId })
