Template.contestCreate.helpers

  events: ->
    Events.find()

  fixtures: ->
    Fixtures.find()

Template.contestCreate.events
  'click .event-options': (e) ->
    fixture = Session.getJSON 'currentFixture' || []
    fixture.push(@)
    console.log fixture
    Session.setJSON 'currentFixture', fixture

  'click .create-fixture': (e) ->
    fixture = Session.getJSON 'currentFixture'
    Meteor.call 'createFixture', { events: fixture }, (error, result) ->
      return console.log error.reason if error

Template.contestCreate.rendered = ->
  # Reset to empty
  Session.setJSON 'currentFixture', []
