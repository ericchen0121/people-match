Template.fixtureCreate.helpers

  allFutureEvents: ->
    Events.find({ startsAt: mq.past })

  weeklyNFLSelection: -> 
    Events.find({ week: Session.getJSON 'fixtureNFLWeekSelection' })

  weeklyNFLFixtures: ->
    Fixtures.find({ week: Session.getJSON 'fixtureNFLWeekSelection' })

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
    schedule = $('select#event-schedule-select').val()
    switch sport
      when 'NFL'
        Meteor.call 'getEventsNFL', schedule
      else
        console.log 'select sport for updating events'

  'change #fixture-schedule-select': (e) ->
    sport = $('select#event-sport-select').val()
    week = $('select#fixture-schedule-select').val()
    Session.setJSON 'fixtureNFLWeekSelection', week

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
    sport = $('select#event-sport-select').val()
    switch sport
      when 'NFL'
        week = $('select#fixture-schedule-select').val()
        Meteor.call 'createFixture', { events: fixture, sport: 'NFL', week: week }, (error, result) ->
          if error
            return console.log error.reason
          else
            # reset fixture to empty
            Session.setJSON 'currentFixture', []

Template.fixtureCreate.rendered = ->
  # Reset to empty
  Session.setJSON 'currentFixture', []
  Session.setJSON 'fixtureNFLWeekSelection', '1' # set default for rendering the proper fixtures upon load