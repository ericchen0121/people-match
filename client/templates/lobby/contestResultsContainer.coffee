Template.contestResultsContainer.events

  'show.bs.modal #contestDetailsModal': (event) ->
    console.log 'this modal event fired'
    triggerEl = $(event.relatedTarget) # Element that triggered the modal
    contestName = triggerEl.data('name') # Extract info from data-* attributes, in this case data-name
    console.log 'the contestName is, ' + contestName
    # If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    # Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    modal = $(event.target)
    console.log 'the modal is', + modal
    modal.find('.modal-title').text(contestName + ' Tournament!')

Template.contestResultsContainer.helpers

  # Presents a human readable moment.js time
  #
  momentify: (time) ->
    moment(time).format('ddd, h:mmA')

  # Powers the contest list view of the lobby
  # Returns an Array of contest objects
  #
  contestsFake: ->
    contestFake =
      {
      contestId: 'abcd123'
      sport: 'NFL'
      contestType: 'h2h'
      contestName: 'NFL - $300000 Escape Bowl'
      guaranteedPrizes: true
      multipleEntries: true
      multipleEntriesAllowed: 25
      entries: 0
      size: 50
      entryFee: 100
      prizes: 100
      starts: new Date()
      slate: [
        {
          event_id: 1,
          gameName: 'PIT @ CIN',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ],
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 2,
          gameName: 'IND @ CLE',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 3,
          gameName: 'CAR @ NO',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 4,
          gameName: 'BUF @ DEN',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 5,
          gameName: 'SF @ OAK',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 6,
          gameName: 'STL @ WAS',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 7,
          gameName: 'HOU @ JAX',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 8,
          gameName: 'PIT @ CIN',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
          },
        {
          event_id: 9,
          gameName: 'IND @ CLE',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 10,
          gameName: 'CAR @ NO',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 10,
          gameName: 'BUF @ DEN',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 11,
          gameName: 'SF @ OAK',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 12,
          gameName: 'STL @ WAS',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        },
        {
          event_id: 13,
          gameName: 'HOU @ JAX',
          startsAt: new Date(),
          teams: [
            {
              team_id: 100
            },
            {
              team_id: 101
            }
          ]
        }
      ],

      prizePayouts:
        [
          {1: 1000}, {2: 500}, {3: 200}, {4: 100}, {5: 50}
        ]
      }
    contestSet = (contestFake for i in [1..10])
    return contestSet

  contestsReal: ->
    Contests.find({})


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
