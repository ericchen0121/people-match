Router.configure

  layoutTemplate: 'layout'

Router.route '/', {name: 'peopleList'}

Router.route '/people'

Router.route '/nfl/players', {name: 'nflPlayersList'}, ->
	@render 'nflPlayersList'

Router.route '/nfl/players/:espn_id', {
  name: 'playerCardPage',
  data: ->
    NflPlayers.findOne({espn_id: parseInt(@params.espn_id)})
}
