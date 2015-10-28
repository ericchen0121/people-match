# THIS FILE IS STARTUP FILE FOR THE METEOR SERVER

# -----------------------------Database Optimizing and Debugging Collection.Find ----------------------------------
# This will console.log all finds on the collection, use this to see whether there are too many calls to the db
# https://groups.google.com/forum/#!msg/meteor-talk/dnnEseBCCiE/l_LHsw-XAWsJ
# 
# console.log('[startup] wrapping Collection.find')

wrappedFind = Meteor.Collection.prototype.find
Meteor.Collection.prototype.find = -> 
  console.log(this._name + '.find', JSON.stringify(arguments))
  return wrappedFind.apply(this, arguments)
  
# ----------------------------------------Indexes ----------------------------------------
# Create a unique compound key on Event, Athlete and Stat Type
AthleteEventStats._ensureIndex( { "api.compoundId": 1 }, { unique: true, sparse: true } )
AthleteEventScores._ensureIndex( { "api.compoundId": 1 }, { unique: true, sparse: true } )

# -------------------------------------- Mongo Distinct ----------------------------------------
# Create a Mongo Distinct Function on a Specific Collection
# via looking at how aggregate was wrapped: https://github.com/meteor/meteor/pull/644
# 
# Add `distinct` method to Collection
path = Npm.require('path')
Future = Npm.require(path.join('fibers', 'future'))

AthleteEventStats.distinct = (key, query) ->
  future = new Future
  @find()._mongo.db.createCollection @_name, (err,collection) =>
    future.throw err if err

    collection.distinct key, query, (err,result) =>
      future.throw(err) if err
      future['return']([true,result]) 
  
  result = future.wait()
  throw result[1] if !result[0]
  result[1]

EventStats.distinct = (key, query) ->
  future = new Future
  @find()._mongo.db.createCollection @_name, (err,collection) =>
    future.throw err if err

    collection.distinct key, query, (err,result) =>
      future.throw(err) if err
      future['return']([true,result]) 
  
  result = future.wait()
  throw result[1] if !result[0]
  result[1]
  
Entries.distinct = (key, query) ->
  future = new Future
  @find()._mongo.db.createCollection @_name, (err,collection) =>
    future.throw err if err

    collection.distinct key, query, (err,result) =>
      future.throw(err) if err
      future['return']([true,result]) 
  
  result = future.wait()
  throw result[1] if !result[0]
  result[1]
  
# ----------------------------------------Fast Render----------------------------------------
# https://github.com/meteorhacks/fast-render#using-fast-renders-route-apis

FastRender.route '/players', ->
  # Fast load these subscriptions to collections
  # This passes the collection data over html for fast rendering of the page
  @subscribe 'nflPlayers'
  @subscribe 'nflTeams'
  @subscribe 'nflSuperstars'

FastRender.route '/chatter', ->
  @subscribe 'commentaries'
  @subscribe 'nflSuperstars'
  @subscribe 'commentariesUsers' # this will slow down when there are many users

FastRender.route '/lobby', ->
  @subscribe 'contests'

FastRender.route '/contest/:contestId/draftteam', (params) ->
  @subscribe 'nflPlayers' #params.contestId
  @subscribe 'nflSuperstars'
  @subscribe 'contests' #params.contestId

# ---------------------------------------- Data Import ---------------------------------------- 
#  nflTeams data to collection
# http://stackoverflow.com/questions/25370332/import-json-file-into-collection-in-server-code-on-startup
# http://stackoverflow.com/questions/12941915/how-to-iterate-through-json-hash-with-coffeescript
#

if @NflTeams.find().count() == 0 # import only when NflTeams data is empty
  console.log('Importing NflTeams to db!!')

  data = EJSON.parse(Assets.getText('assets/nflTeams.json'))

  for key, value of data
    @NflTeams.insert(value)

# ---------------------------------------- Houston Admin ---------------------------------------- 
# Houston.hide_collection(EventStats)
# Houston.hide_collection(AthleteEventStats)
# Houston.hide_collection(AthleteEventScores)
# Houston.hide_collection(AthleteEventData)
# Houston.hide_collection(AthleteEventStatsAggregate)

# ---------------------------------------- Venmo Integration ---------------------------------------- 
# docs: https://atmospherejs.com/pcooney10/accounts-venmo
# 
ServiceConfiguration.configurations.remove({
  service: "venmo"
})

ServiceConfiguration.configurations.insert({
  service: "venmo",
  clientId: "3052",
  scope: "make_payments+access_friends+access_email",
  secret: "KuwzCeRH3gZzXUcgpVKcG5sD5wYxzpT2"
});
