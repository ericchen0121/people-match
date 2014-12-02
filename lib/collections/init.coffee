# Set Up Collections
#

# For the People page
@People = new Mongo.Collection("people")

# NFL Players
@NflPlayers = new Mongo.Collection('nflPlayers')
@NflTeams = new Mongo.Collection('nflTeams')

# Bookmarked Players
@NflSuperstars = new Mongo.Collection('nflSuperstars')

@Commentaries = new Mongo.Collection('commentaries')
@CommentariesUsers = new Mongo.Collection('commentariesUsers') # necessary to see all users' Names and Pictures

# Implement a Search across Nfl Players
# https://github.com/matteodem/meteor-easy-search/wiki/Getting-started
#
EasySearch.createSearchIndex('nflPlayersSearch', {
    'field' : ['full_name'],            # required, searchable field(s)
    'collection' : NflPlayers,          # required, Mongo Collection
    'limit' : 3                         # not required, default is 10
})
