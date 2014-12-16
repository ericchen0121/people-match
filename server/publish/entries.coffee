Meteor.publish 'entries', ->
  # Meteor.userId can only be invoked in method calls. Use this.userId in publish functions.
  Entries.find({ userId: this.userId })
