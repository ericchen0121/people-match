People = new Mongo.Collection("people")

if Meteor.isClient
  # Helpers
  # Helpers pass Data into Templates
  Template.people.helpers({
    people: ->
      return People.find({})
  });

  # Event listeners
  Template.add_person_form.events({
    'submit .new-person': (event) -> 
      # Store values via form
      name = event.target.name.value
      department = event.target.department.value
      title = event.target.title.value
      client = event.target.client.value

      # Add to db
      People.insert({
        name: name,
        department: department,
        title: title,
        client: client
      })
      
      # Clear form
      event.target.name.value = ''
      event.target.department.value = ''
      event.target.title.value = ''
      event.target.client.value = ''

      # Prevent default form submit
      return false
  })


if Meteor.isServer
  Meteor.startup( ->
    # code to run on server at startup
  )
