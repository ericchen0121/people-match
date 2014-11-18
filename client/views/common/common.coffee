Template.avatarImage.helpers

    user: ->
      Meteor.user()

    profileName: ->
      Meteor.user().profile.name
