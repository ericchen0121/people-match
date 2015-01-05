# extra user session data
Meteor.subscribe 'userData'

# Collections
Meteor.subscribe 'people'

Meteor.subscribe 'nflPlayers'
Meteor.subscribe 'nflTeams'
Meteor.subscribe 'nflSuperstars'

Meteor.subscribe 'commentaries'

Meteor.subscribe 'entries'

Meteor.subscribe 'contests'
Meteor.subscribe 'fixtures'
Meteor.subscribe 'events'

# must publish another collection with users' info, since autopublish is off
# http://stackoverflow.com/questions/20502638/meteor-subscribe-and-display-users-count/20503982#20503982
Meteor.subscribe 'commentariesUsers'
