People = new Mongo.Collection("people")

if (Meteor.isClient) {
  // pass data into templates using helpers
  Template.people.helpers({
    people: function() {
      return People.find({})
    }
  });

  Template.add_person_form.events({
    'submit .new-person': function(event){
      // Store values via form
      var name = event.target.name.value;
      var department = event.target.department.value;
      var title = event.target.title.value;
      var client = event.target.client.value;

      // Add to db
      People.insert({
        name: name,
        department: department,
        title: title,
        client: client
      })
      
      // Clear form
      event.target.name.value = ''
      event.target.department.value = ''
      event.target.title.value = ''
      event.target.client.value = ''

      // Prevent default form submit
      return false
    }
  })
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    // code to run on server at startup
  });
}
