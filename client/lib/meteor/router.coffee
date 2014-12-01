Router.configure

  layoutTemplate: 'layout',
  loadingTemplate: 'loading',
  notFoundTemplate: 'fourOhFour'

# View the Players Application
# 
Router.route '/', {name: 'nflPlayersListLayout'}, ->
	# render this template in the yield block of the main template
	@render 'nflPlayersListLayout'
 
Router.route '/nfl/players/name/:first_name-:last_name', {
	# render the playerCardPage template
  name: 'playerCardPage',
  data: ->
    # render data with route's parameters
    NflPlayers.findOne({first_name: @params.first_name, last_name: @params.last_name })
}

# This doesn't work as expected since the nflPlayersList template relies on teh
# Session.get 'nflPosition', which is a global...

# Router.route '/nfl/players/team/:team', {
# 	name: 'nflPlayersList', 
# 	data: ->
# 		NflPlayers.find({ team: @params.team })
# }
