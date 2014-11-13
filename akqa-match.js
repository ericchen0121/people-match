if (Meteor.isClient) {
  // counter starts at 0
  Session.setDefault("counter", 0);

  // Q: do we put templates in this file?
  Template.people.helpers({
    people: [
      { name: 'Eric Chen', department: 'developer', title: 'associate web dev', client: 'Audi' },
      { name: 'Brandon Bilfield', department: 'developer', title: 'technical delivery manager', client: 'Audi'},
      { name: 'Tyler Burton', department: 'developer', title: 'sr. dev', client: 'Audi' },
      { name: 'Michael Moriarty', department: 'developer', title: 'sr. dev', client: 'Audi' },
      { name: 'Jeff Wesson', department: 'developer', title: 'sr. dev', client: 'Audi' },
      { name: 'Eric Clifford', department: 'developer', title: 'technical architect', client: 'Audi' },
      { name: 'Ryan Brewster', department: 'developer', title: 'sr. dev', client: 'Audi' },
      { name: 'Saj Momin', department: 'developer', title: 'cq guy', client: 'Audi' },
      { name: 'Mohan', department: 'developer', title: 'cq guy', client: 'Audi' },
      { name: 'tbd', department: 'tbd', title: 'tbd', client: 'Audi' },
      { name: 'tbd', department: 'tbd', title: 'tbd', client: 'Audi' },
      { name: 'tbd', department: 'tbd', title: 'tbd', client: 'Audi' },
      { name: 'tbd', department: 'tbd', title: 'tbd', client: 'Audi' },
      { name: 'tbd', department: 'tbd', title: 'tbd', client: 'Audi' },
      { name: 'tbd', department: 'tbd', title: 'tbd', client: 'Audi' },
      { name: 'tbd', department: 'tbd', title: 'tbd', client: 'Audi' },
      { name: 'tbd', department: 'tbd', title: 'tbd', client: 'Audi' },
      { name: 'tbd', department: 'tbd', title: 'tbd', client: 'Audi' },
      { name: 'tbd', department: 'tbd', title: 'tbd', client: 'Audi' }
    ]
  });

  // Template.person.events({
  //   'click button': function () {
  //     // increment the counter when button is clicked
  //     Session.set("counter", Session.get("counter") + 1);
  //   }
  // });
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    // code to run on server at startup
  });
}
