FastRender.route '/nfl/players', ->
  @subscribe 'nflPlayers'


# Import nflTeams data to collection
# http://stackoverflow.com/questions/25370332/import-json-file-into-collection-in-server-code-on-startup
# http://stackoverflow.com/questions/12941915/how-to-iterate-through-json-hash-with-coffeescript
#

# import only when NflTeams data is empty
if @NflTeams.find().count() == 0
  console.log('Importing NflTeams to db!')

  data = EJSON.parse(Assets.getText('assets/nflTeams.json'))

  for key, value of data
    @NflTeams.insert(value)
