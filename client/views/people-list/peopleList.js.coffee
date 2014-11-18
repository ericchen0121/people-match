# Helpers pass Data into Templates

Template.people.helpers

  people: ->
    if Session.get 'showTech'
      People.find({department: 'tech'}, {sort: {name: 1}})
    else
      People.find({}, {sort: {name: 1}})

  showTech: ->
    Session.get 'showTech'

  techPeopleCount: ->
    People.find({department: 'tech'}).count()

  totalPeopleCount: ->
    People.find({}).count()


Template.peopleList.helpers

  user: ->
    Meteor.user()


# Event listeners

Template.people.events

   'change .show-tech input': (event) ->
    # Set boolean if checked
    Session.set 'showTech', event.target.checked

Template.personDescription.events

  'click .delete': ->
    Meteor.call 'removePerson', @_id

Template.addPersonForm.events
  'submit .new-person': (event) ->
    # Store values via form
    name = event.target.name.value
    department = event.target.department.value
    title = event.target.title.value
    client = event.target.client.value

    Meteor.call('insertPerson', {
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
