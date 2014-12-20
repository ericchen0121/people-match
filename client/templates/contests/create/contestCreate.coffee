Template.contestCreate.helpers

  events: ->
    Events.find()

  fixtures: ->
    Fixtures.find()

  # for use within fixture data context
  fixturesEventCount: ->
    @.events.length

Template.contestCreate.events
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

Template.contestCreate.rendered = ->
  # Reset to empty
  Session.setJSON 'currentFixture', []
