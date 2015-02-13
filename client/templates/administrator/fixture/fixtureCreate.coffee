Template.fixtureCreate.helpers

  allFutureEvents: ->
    # Events.find({ startsAt: mq.future })
    Events.find({ startsAt: mq.lastFewDays })

  fixtures: ->
    # Fixtures.find({ startsAt: mq.future })
    Fixtures.find({ startsAt: mq.lastFewDays })

  # @param-data [obj] a Fixture 
  # 
  fixturesEventCount: ->
    fixture = @
    fixture.events.length

  # TODO: Refactor... There may be a better way to render out a cursor call with a nested variable
  # but this is the way I know how to do it now. This is basically hardcoding with
  # the understanding that @ context is a fixture and it has an array called @.events

  # @param-data [obj] a Fixture 
  # 
  fixturesEvents: ->
    fixture = @
    fixture.events

Template.fixtureCreate.events
  'click .update-events': (e) ->
    sport = $('select#event-sport-select').val()
    schedule = +$('select#event-schedule-select').val()
    Meteor.call 'getEvents', sport, schedule 

  'click .remove-fixture': (e) ->
    fixture = @
    Meteor.call 'removeFixture', fixture._id

  # @param-data [obj] an Event 
  # 
  'click .event-options': (e) ->
    event = @
    # construct Fixture from selected Events
    fixtureArray = Session.getJSON 'currentFixture' || []
    fixtureArray.push(event)
    Session.setJSON 'currentFixture', fixtureArray

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
