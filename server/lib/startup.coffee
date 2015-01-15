# Indexes
# Create a unique compound key on Event, Athlete and Stat Type
AthleteEventStats._ensureIndex( { "compoundId": 1 }, { unique: true, sparse: true } )
AthleteEventScores._ensureIndex( { "api.compoundId": 1 }, { unique: true, sparse: true } )

# Add `distinct` method to Collection
path = Npm.require('path')
Future = Npm.require(path.join('fibers', 'future'))

# distinct() definition from https://github.com/meteor/meteor/pull/644
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

# Fast Render APIs, available only on the server
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

# Import nflTeams data to collection
# http://stackoverflow.com/questions/25370332/import-json-file-into-collection-in-server-code-on-startup
# http://stackoverflow.com/questions/12941915/how-to-iterate-through-json-hash-with-coffeescript
#

# import only when NflTeams data is empty
if @NflTeams.find().count() == 0
  console.log('Importing NflTeams to db!!')

  data = EJSON.parse(Assets.getText('assets/nflTeams.json'))

  for key, value of data
    @NflTeams.insert(value)
