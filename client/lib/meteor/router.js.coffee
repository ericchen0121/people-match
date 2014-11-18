Router.configure

  layoutTemplate: 'layout'

Router.route '/', {name: 'peopleList'}

Router.route '/people'

Router.route '/nfl', {name: 'nflPlayersList'}, ->
	@render 'nflPlayersList'