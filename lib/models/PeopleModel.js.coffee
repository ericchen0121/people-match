Meteor.methods({
  getPeopleCount: ->
    People.find({}).count()

  , insertPerson: (person) ->
   	People.insert person

  , removePerson: (id) ->
  	People.remove id
})
