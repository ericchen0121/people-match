Meteor.methods

  fetchNFLWeeklySlates: () ->
    url = 'http://api.sportsdatallc.org/nfl-t1/2014/REG/16/schedule.xml?api_key=u5jw8rhnqtqvr5k8zwgnjm3k'
    APIresponse = HTTP.get url, { timeout: 10000 }

    if APIresponse.statusCode == 200
      parser = new xml2js.Parser()
      parser.parseString APIresponse.content, (err, result) ->
        console.log result #
        console.log result.games.game
        console.log 'Done.'

# Meteor.call 'fetchNFLWeeklySlates'
