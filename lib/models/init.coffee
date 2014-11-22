# Set Up Collections
@People = new Mongo.Collection("people")
@NflPlayers = new Mongo.Collection('nflPlayers')

# EasySearch for Search Indexes
# To add in other fields to search against, simply add it to the first argument list
# https://github.com/matteodem/meteor-easy-search/wiki/Getting-started
# NflPlayers.initEasySearch(['full_name'], {
#     'limit' : 3
# })

EasySearch.createSearchIndex('nflPlayersSearch', {
    'field' : ['full_name'],            # required, searchable field(s)
    'collection' : NflPlayers,          # required, Mongo Collection
    'limit' : 3                         # not required, default is 10
});
