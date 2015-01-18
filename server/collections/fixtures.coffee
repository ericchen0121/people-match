Fixtures.before.insert (userId, doc) ->
  # TODO: probably want to do this for the update action, if supported
  earliestEventStartsAt = ''

  for event in doc.events
    if earliestEventStartsAt == ''
      earliestEventStartsAt = event.scheduled
    else if earliestEventStartsAt > event.scheduled
      earliestEventStartsAt = event.scheduled

  doc.startsAt = new Date(earliestEventStartsAt).getTime()

Meteor.methods

  createFixture: (fixture) ->
    Fixtures.insert(fixture)

  removeFixture: (id) ->
    Fixtures.remove({_id: id})