# May want to rename this activeContests
# or make the $or statement a "contains" live - upcoming or live - active
Meteor.publish 'contests', ->
  # Contests.find({  $or: [{ status: 'upcoming' }, { status: 'live'}] })
  Contests.find({})
