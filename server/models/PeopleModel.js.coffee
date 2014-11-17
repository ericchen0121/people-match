Meteor.methods

  insertPerson: (person) ->
   	People.insert person, 

  removePerson: (id) ->
  	People.remove id
  	