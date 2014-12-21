Template.contestCreate.helpers

  fixtures: ->
    Fixtures.find()

  fixturesEventCount: ->
    @.events.length

  fixturesEvents: ->
    @.events

# Template.contestCreate.rendered = ->
#   Session.set('')
