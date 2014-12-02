# This sets up a reactive join on commentaries and users
# https://atmospherejs.com/reywood/publish-composite
#
Meteor.publishComposite('commentaries', {
  # This is the top level collection, finding all the commentaries
  find: ->
    # or could sort on 'lastActionTime' if that exists ;)
    return Commentaries.find({})

  # children is an array of object literals with more finds
  # argument is the first top level collection, must return a cursor
  # @userId will find the current user's id on the server method
  children: [{
    find: (commentary) ->
      return Meteor.users.find( commentary.createdUserId )
  }]
})

Meteor.publish 'commentariesUsers', ->
  Meteor.users.find {},
    fields:
      profile: 1
  # this publishes all users, but only their profile...
  # TODO: only publish users of the commentaries that are shown
  # http://stackoverflow.com/questions/20825758/meteor-how-to-publish-cursor-that-is-depending-on-cursor-of-other-collection
