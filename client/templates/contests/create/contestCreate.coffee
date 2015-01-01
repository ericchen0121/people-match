Template.contestCreate.helpers

  availableFixtures: ->
    # Fixtures.find(MQH.startsInFuture, MQH.startsInFutureSortAsc)
    Fixtures.find() # temporary until we can grab new POSTseason events

  # Basically, this is neccessary as a template helper because we can't
  # '{{events}}' is a reserved word within helpers. However, we also have
  # a key on a collection named events. This is unfortunate, but its the most obvious
  # and generic name for an event (without specifying it as a "game" or "sporting event" or something else)
  # Template.events.helpers is a reserved method
  # TODO: either make this a global helper or change the key 'Fixtures.events'
  fixtureEvents: ->
    @.events

  fixtureEventCount: ->
    @.events.length


  fixtureSelected: ->
    selectedId = Session.get('contestFixtureSelection')
    if @._id == selectedId
      return 'is-expanded'

  availableLeagueSizes: ->
    [3..20]

  availableEntryFees: ->
    [{name: 'Free', value: 0},
     {name:'$2', value: 2},
     {name:'$5', value: 5},
     {name:'$10', value: 10},
     {name:'$25', value: 25},
     {name:'$50', value: 50},
     {name:'$100', value: 100}]

  availablePrizeStructures: ->
    # can make this an object like availableEntryFees
    ['Winner takes all', 'Top 3 get prizes', 'Top third gets prizes']

Template.contestCreate.rendered = ->
  Session.set 'contestFixtureSelection', $('select#contest-fixture-select option:selected').val()

Template.contestCreate.events
  'change select#contest-fixture-select': (e) ->
    Session.set 'contestFixtureSelection', $('select#contest-fixture-select option:selected').val()

  # TODO: write the template or helper method that changes the sport based
  # on the Events obj's sport attribute. Currently it doesn't filter by sport at all.
  #

  'click .create-contest': (e) ->
    # TODO: server-side: prize payouts
    # Standardize naming
    #TODO: should this be using [name=xx] as BP?
    size = +$('select#contest-size-select').val()
    entryFee = +$('select#entry-fee-select').val()
    prizes = (size * entryFee) * .9 # TODO: can do this on server-side

    contest = {
      sport: $('input:radio[name=sport-select]:checked').val()
      contestType: $('input:radio[name=contest-type-select]:checked').val()
      contestName: $('input:text[name=league-name]').val()
      guaranteedPrizes: true
      multipleEntries: true
      multipleEntriesAllowed: 25
      publicStatus: $('input:radio[name=public-status-select]:checked').val()
      entryCount: 0
      entrySize: size
      entryFee: entryFee
      prizes: prizes
      prizeFormat: $('select#prize-structure-select').val()
      salaryCap: 60000
      fixture:
        _id: $('select#contest-fixture-select').val()
      # prizePayouts: 'test'
    }

    Meteor.call 'contestInsert', contest
