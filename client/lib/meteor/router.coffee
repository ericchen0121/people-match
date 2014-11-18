Router.configure

  layoutTemplate: 'layout'

Router.route '/', {name: 'peopleList'}

Router.route '/people'

Router.route '/nfl/players', {name: 'nflPlayersList'}, ->
	@render 'nflPlayersList'
