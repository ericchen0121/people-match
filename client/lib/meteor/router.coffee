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

Router.route '/lobby', {
  name: 'lobbyLayout'
  waitOn: ->
    Meteor.subscribe 'contests'
  }

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

Router.route '/contest/create', {
  name: 'contestCreateLayout'
  waitOn: ->
    Meteor.subscribe 'fixtures'
}

# TODO: Change this to ._id to take advantage of it finding the _id property on the contest automatically
Router.route '/contest/:contestId/draftteam', {
  name: 'contestLayout',
  data: ->
    Contests.findOne({ _id: @params.contestId })
}

Router.route '/entry/:_id', {
  name: 'entryLayout',
  data: ->
    Entries.findOne({ _id: @params._id })
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
