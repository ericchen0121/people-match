Template.contestResultsContainer.events

  # Twitter Bootstrap Modal JS Events
  #
  'show.bs.modal #contestDetailsModal': (event) ->
    # If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    # Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.

    # Get Data-* Properties
    triggerEl = $(event.relatedTarget) # Element that triggered the modal
    contestName = triggerEl.data('name') # Extract info from data-* attributes, in this case data-name

    # data = $(this).data
    # console.log 'this is the data', data

    # Set Modal content
    modal = $(event.target)
    modal.find('.modal-title').text(contestName + ' Tournament!')

  # QUESTION: Why doesn't this event handler belong in the
  # inner 'contestDetailsModal' template?
  # Initializes Bootstrap JS Tabs
  # http://getbootstrap.com/javascript/#tabs
  #
  'click ul.nav.nav-tabs > li > a': (event) ->
    event.preventDefault()
    $(event.target).tab('show')

Template.contestDetailsModal.helpers

  readablePrizePayouts: ->
    '1st: $500'

Template.contestResultsContainer.helpers

  # Powers the contest list view of the lobby
  # Returns an Array of contest objects
  #
  contestsFake: ->
    contestFake =
    {
      contestId: 'abcd123'
      sport: 'NFL'
      contestType: 'h2h'
      contestName: 'NFL - Sweet Sweet Nectar Freeroll'
      guaranteedPrizes: true
      multipleEntries: true
      multipleEntriesAllowed: 25
      entries: 7
      size: 50
      entryFee: 100
      prizes: 100
      starts: Date.now()
      lineupPositions: {
        'QB': 1
        'RB': 1
        'WR': 3
        'TE': 1
        'K': 1
        'DEF': 1
      },
      salaryCap: 60000
      slate: [
        {
          eventId: 1,
          gameName: 'PIT @ CIN',
          startsAt: new Date(),
          teams: [
            {
              teamId: 100
            },
            {
              teamId: 101
            }
          ],
          teams: [
            {
              teamId: 100
            },
            {
              teamId: 101
            }
          ]
        },
        {
          eventId: 2,
          gameName: 'IND @ CLE',
          startsAt: new Date(),
          teams: [
            {
              teamId: 100
            },
            {
              teamId: 101
            }
          ]
        },
        {
          eventId: 3,
          gameName: 'CAR @ NO',
          startsAt: new Date(),
          teams: [
            {
              teamId: 100
            },
            {
              teamId: 101
            }
          ]
        },
        {
          eventId: 4,
          gameName: 'BUF @ DEN',
          startsAt: new Date(),
          teams: [
            {
              teamId: 100
            },
            {
              teamId: 101
            }
          ]
        },
        {
          eventId: 5,
          gameName: 'SF @ OAK',
          startsAt: new Date(),
          teams: [
            {
              teamId: 100
            },
            {
              teamId: 101
            }
          ]
        },
        {
          eventId: 6,
          gameName: 'STL @ WAS',
          startsAt: new Date(),
          teams: [
            {
              teamId: 100
            },
            {
              teamId: 101
            }
          ]
        }
      ],
      prizePayouts:
        [
          {1: 1000}, {2: 500}, {3: 200}, {4: 100}, {5: 50}, {'6-10', 10}
        ]
    }
    contestSet = (contestFake for i in [1..10])
    return contestSet

  # When the contests are in the DB, flip this switch to turn it on!
  contestsReal: ->
    Contests.find()


Template.contestResultsContainer.rendered = ->
  # Uses Malihu's scrollbar Meteor package, which as of 12/4/2014 is on v3.0.3
  # v3.0.3 GH: https://github.com/malihu/malihu-custom-scrollbar-plugin/tree/4c5c287a28b5294408c16c5bf5e024e0f0059685
  # Color Themes: http://manos.malihu.gr/repository/custom-scrollbar/demo/examples/scrollbar_themes_demo.html
  # Atmosphere Package: https://atmospherejs.com/maazalik/malihu-jquery-custom-scrollbar
  #
  @$('#contestResultsTable').mCustomScrollbar
    theme: 'minimal-dark'
    autoHideScrollbar: true
    scrollInertia: 300
