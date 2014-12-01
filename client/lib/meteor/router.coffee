Router.configure

  layoutTemplate: 'navLayout',
  loadingTemplate: 'loading',
  notFoundTemplate: 'fourOhFour'

# View the Players Application
#
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

# This doesn't work as expected since the nflPlayersList template relies on teh
# Session.get 'nflPosition', which is a global...

# Router.route '/nfl/players/team/:team', {
# 	name: 'nflPlayersList',
# 	data: ->
# 		NflPlayers.find({ team: @params.team })
# }
