Template.fixtureCreate.helpers

  allFutureEvents: ->
    # Events.find(MQH.startsInFuture)
    Events.find() # temporary to see events, since SD api doesn't yet have POSTseason sched exposed

  fixtures: ->
    # Fixtures.find(MQH.startsInFuture, MQH.startsInFutureSortAsc)
    Fixtures.find() # temporary to see events, since SD api doesn't yet have POSTseason sched exposed

  # for use within fixture data context
  fixturesEventCount: ->
    @.events.length

  # for use within fixture data context.
  # TODO: Refactor... There may be a better way to render out a cursor call with a nested variable
  # but this is the way I know how to do it now. This is basically hardcoding with
  # the understanding that @ context is a fixture and it has an array called @.events
  fixturesEvents: ->
    @.events

Template.fixtureCreate.events
  'click .event-options': (e) ->
    fixture = Session.getJSON 'currentFixture' || []
    fixture.push(@)
    console.log fixture
    Session.setJSON 'currentFixture', fixture

  'click .create-fixture': (e) ->
    fixture = Session.getJSON 'currentFixture'
    Meteor.call 'createFixture', { events: fixture }, (error, result) ->
      if error
        return console.log error.reason
      else
        # reset fixture to empty
        Session.setJSON 'currentFixture', []

Template.fixtureCreate.rendered = ->
  # Reset to empty
  Session.setJSON 'currentFixture', []
