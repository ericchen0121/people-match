# ---------------CONFIGURATION --------------
Router.configure

  layoutTemplate: 'navLayout',
  loadingTemplate: 'loading',
  notFoundTemplate: 'fourOhFour'

# --------------- ACCOUNTS --------------
# Package: https://github.com/meteor-useraccounts/core/ 
# Docs: https://github.com/meteor-useraccounts/core/blob/master/Guide.md#internal-states
# 
# AccountsTemplates.configureRoute('signIn')
AccountsTemplates.configureRoute('signIn', {
    name: 'signin',
    path: '/login',
    template: 'myLogin',
    # layoutTemplate: 'myLayout',
    redirect: '/lobby',
})

# --------------- SUBSCRIPTION --------------
# Package: meteorhacks/subs-manager 
# Notes: for subscriptions all waitOn: calls use subs instead of Meteor.subscribe
# 
subs = new SubsManager()


# --------------- ROUTES --------------
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

# --------------- VIEW ALL CONTESTS --------------
Router.route '/lobby', {
  name: 'lobbyLayout'
  waitOn: ->
    subs.subscribe 'contests'
}

# --------------- VIEW ALL CATEGORY CONTEST --------------
Router.route '/upcoming', {
    name: 'upcomingContestListLayout'
    waitOn: ->
      subs.subscribe 'entries'
}

Router.route '/live', {
    name: 'liveContestListLayout'
    waitOn: ->
      subs.subscribe 'entries'
}

Router.route '/history', {
    name: 'historyContestListLayout'
    waitOn: ->
      subs.subscribe 'entries'
 }

# --------------- VIEW ONE --------------
# TODO: Change this to ._id to take advantage of it finding the _id property on the contest automatically
Router.route '/contest/:contestId/draftteam', {
  name: 'contestLayout',
  data: ->
    Contests.findOne({ _id: @params.contestId })
}

Router.route '/entry/:_id', {
  name: 'entryLayout',
  waitOn: ->
    [
      subs.subscribe 'entries', @params._id
      subs.subscribe 'athleteEventScoresOnEntry', @params._id
    ]
  data: ->
    Entries.findOne({ _id: @params._id })
}
# --------------- ADMIN --------------
Router.route '/administrator/fixture/create', {
  name: 'fixtureCreateLayout'
  waitOn: ->
    subs.subscribe 'events'
}

Router.route '/administrator/contest/create', {
  name: 'contestCreateLayout'
  waitOn: ->
    subs.subscribe 'fixtures'
}

Router.route '/administrator/events/score', {
  name: 'scoreLayout'
  waitOn: ->
    subs.subscribe 'events'
}
