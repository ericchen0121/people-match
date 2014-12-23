# # Collection-hooks adds attributes before insert
Contests.before.insert (userId, doc) ->
  # standard add-ons
  doc.createdAt = Date.now()
  doc.updateAt = Date.now()
  doc.userId = userId

  doc.startsAt = Fixtures.findOne({ _id: doc.fixture.id }).startsAt
  # Embed the events into the doc
  doc.fixture.events = Fixtures.findOne({ _id: doc.fixture.id }).events


Meteor.methods
  contestInsert: (contest) ->
    Contests.insert(contest)
