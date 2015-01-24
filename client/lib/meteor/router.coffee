# uses meteorhacks/subs-manager for subscriptions
subs = new SubsManager()

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
    subs.subscribe 'contests'
  }

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
