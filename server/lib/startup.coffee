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

FastRender.route '/contest/:contestId', (params) ->
  @subscribe 'nflPlayers'#params.contestId
  @subscribe 'nflSuperstars'
  @subscribe 'contests'#params.contestId

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
