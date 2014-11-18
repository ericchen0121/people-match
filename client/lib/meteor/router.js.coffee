Router.configure({

  layoutTemplate: 'layout'

  # TODO: waitOn: ->
  	# Meteor.
})

Router.route '/', {name: 'peopleList'}

Router.route '/people'
