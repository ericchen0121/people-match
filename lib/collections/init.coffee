# Set Up Collections
@People = new Mongo.Collection("people")
@NflPlayers = new Mongo.Collection('nflPlayers')

# EasySearch for Search Indexes
# https://github.com/matteodem/meteor-easy-search/wiki/Getting-started
#
EasySearch.createSearchIndex('nflPlayersSearch', {
    'field' : ['full_name'],            # required, searchable field(s)
    'collection' : NflPlayers,          # required, Mongo Collection
    'limit' : 3                         # not required, default is 10
})

@NflTeams = new Mongo.Collection('nflTeams')

@NflSuperstars = new Mongo.Collection('nflSuperstars')
