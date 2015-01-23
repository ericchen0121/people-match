# Collection-hooks adds attributes before insert
Contests.before.insert (userId, doc) ->
  # standard add-ons
  doc.createdAt = doc.createdAt || new Date().toISOString()
  doc.updatedAt = new Date().toISOString()
  doc.userId = userId

  # TODO: Consider embedding the entire fixture into the Contest Obj
  # copy over the startsAt time from the fixture to the contest
  doc.startsAt = Fixtures.findOne({ _id: doc.fixture._id }).startsAt
  # Embed the fixture events into the doc
  doc.fixture.events = Fixtures.findOne({ _id: doc.fixture._id }).events


Meteor.methods
  contestInsert: (contest) ->
    Contests.insert(contest)
