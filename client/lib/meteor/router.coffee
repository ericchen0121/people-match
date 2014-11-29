Router.configure

  layoutTemplate: 'layout',
  loadingTemplate: 'loading',
  notFoundTemplate: 'fourOhFour'


Router.route '/', {name: 'peopleList'}

Router.route '/people'

# View the Players Application
# 
Router.route '/nfl/players', {name: 'nflPlayersListLayout'}, ->
	# render this template in the yield block of the main template
	@render 'nflPlayersListLayout'

# View Individual Player Profile 
# 
Router.route '/nfl/players/:espn_id', {
  name: 'playerCardPage',
  data: ->
    # render data with route's parameters
    NflPlayers.findOne({espn_id: parseInt(@params.espn_id)})
}

# 
Router.route '/nfl/myteam'
