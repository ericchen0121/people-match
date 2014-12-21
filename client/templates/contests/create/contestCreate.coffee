Template.contestCreate.helpers

  fixtures: ->
    Fixtures.find()

  fixturesEventCount: ->
    @.events.length
