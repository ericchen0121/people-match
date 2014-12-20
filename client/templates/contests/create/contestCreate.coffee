Template.contestCreate.helpers

  fixtures: ->
    Fixtures.find()

  fixturesEventCount: ->
    @.events.length

  # for use within fixture data context.
  # TODO: Refactor... There may be a better way to render out a cursor call with a nested variable
  # but this is the way I know how to do it now. This is basically hardcoding with
  # the understanding that @ context is a fixture and it has an array called @.events
  fixturesEvents: ->
    @.events
