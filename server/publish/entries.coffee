Meteor.publish 'entries', ->
  Entries.find({ userId: this.userId })
