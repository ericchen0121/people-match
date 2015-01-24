Fixtures.before.insert (userId, doc) ->
  # TODO: probably want to do this for the update action, if supported
  earliestEventStartsAt = null

  # set Fixture.startsAt value to the earliest start time
  for event in doc.events
    if !earliestEventStartsAt
      earliestEventStartsAt = event.startsAt
    else if earliestEventStartsAt > event.startsAt
      earliestEventStartsAt = event.startsAt

  doc.startsAt = earliestEventStartsAt

Meteor.methods

  createFixture: (fixture) ->
    Fixtures.insert(fixture)

  removeFixture: (id) ->
    Fixtures.remove({_id: id})