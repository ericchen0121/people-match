Template.contestCreate.helpers

  fixtures: ->
    Fixtures.find()

  fixturesEventCount: ->
    @.events.length

  fixturesEvents: ->
    @.events

  fixtureSelected: ->
    selectedId = Session.get('contestFixtureSelection')
    if @._id == selectedId
      return 'is-expanded'

Template.contestCreate.rendered = ->
  Session.set 'contestFixtureSelection', $('select#contest-fixture-select option:selected').val()

Template.contestCreate.events
  'change select#contest-fixture-select': (e) ->
    Session.set 'contestFixtureSelection', $('select#contest-fixture-select option:selected').val()
