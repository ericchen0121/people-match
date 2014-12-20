Router.configure

  layoutTemplate: 'navLayout',
  loadingTemplate: 'loading',
  notFoundTemplate: 'fourOhFour'

# View the Players Application
#
Router.route '/', ->
  @render 'chatterLayout'

Router.route '/chatter', {name: 'chatterLayout'}, ->
  @render 'chatterLayout'

Router.route '/players', {name: 'nflPlayersListLayout'}, ->
	# render this template in the yield block of the main template
	@render 'nflPlayersListLayout'

Router.route '/players/:espn_id/:first_name-:last_name', {
	# render the playerCardPage template
  name: 'playerCardPage',
  data: ->
    # render data with route's parameters
    NflPlayers.findOne({espn_id: parseInt @params.espn_id })
}

Router.route '/lobby', {name: 'lobbyLayout'}, ->
  @render 'lobbyLayout'

Router.route '/upcoming', {
    name: 'upcomingContestListLayout'
    waitOn: ->
      Meteor.subscribe 'entries'
  }

Router.route '/live', {
    name: 'liveContestListLayout'
    waitOn: ->
      Meteor.subscribe 'entries'
  }

Router.route '/history', {
    name: 'historyContestListLayout'
    waitOn: ->
      Meteor.subscribe 'entries'
  }

Router.route '/fixture/create', {
  name: 'fixtureCreateLayout'
  waitOn: ->
    Meteor.subscribe 'events'
}

Router.route '/contest/1234/draftteam', {
  name: 'contestLayout',
  data: ->
    # Contests.findOne({_id: @params.contestId})
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
      prizeFormat: 'Winner Takes All'
      starts: new Date()
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
}

# TODO: do I need to make a upsert or insert :before the route is hit?
# This is how Victiv does it, they generate an entryId, attach it to the DOM, and use it
# This creates some problems, namely having to generate the entryId, and creating the id before its necessary
#  The alternative is to send the user to the contest.
# Router.route '/contest/entry/:entryId', {
#   name: 'entryLayout',
#   data: ->
#     Entries.findOne @params.entryId
# }

# Router.route '/contestentry/:contest_id'

# This doesn't work as expected since the nflPlayersList template relies on teh
# Session.get 'nflPosition', which is a global...

# Router.route '/nfl/players/team/:team', {
# 	name: 'nflPlayersList',
# 	data: ->
# 		NflPlayers.find({ team: @params.team })
# }
