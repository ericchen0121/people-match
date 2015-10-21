# Collection-hooks adds attributes before insert
Contests.before.insert (userId, doc) ->
  # standard add-ons
  doc.createdAt = doc.createdAt || new Date().toISOString()
  doc.updatedAt = new Date().toISOString()
  doc.userId = userId

  # TODO: Consider embedding the entire fixture into the Contest Obj
  # copy over the startsAt time from the fixture to the contest
  fixture = Fixtures.findOne({ _id: doc.fixture._id })
  doc.startsAt = fixture.startsAt
  # Embed the fixture events into the doc
  doc.fixture.events = fixture.events
  doc.week = fixture.week

Meteor.methods
  contestInsert: (contest) ->
    Contests.insert(contest)
