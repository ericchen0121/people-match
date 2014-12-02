Template.commentaryCard.helpers
  createdUser: ->
    # This helper is used inside of the {{#each commentaries}} block
    # Therefore, this/@ referes to each commentary object, @userId is a commentary's user id property
    Meteor.users.findOne {_id: @userId }
