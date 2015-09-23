  # https://github.com/matb33/meteor-collection-hooks#beforeupdateuserid-doc-fieldnames-modifier-options
EventStats.before.update (userId, doc, fieldNames, modifier, options) ->

  modifier.$set.createdAt = modifier.$set.createdAt || new Date().toISOString()
  modifier.$set.updatedAt = new Date().toISOString()

Meteor.methods
  # populates EventStats Collection from SD Api
  # This method continously overwrites the EventStat document with new information
  # during the course of the game. 
  # 
  getEventStatsNFL: (sport, week, awayTeam, homeTeam) =>
    console.log 'UPDATING EVENT STATS', sport, week, awayTeam, homeTeam
    switch sport
      when 'NFL'
        eventStats = @sd.NFLApi.getGameStats week, awayTeam, homeTeam
        sport = 'NFL'

    if eventStats
      EventStats.update({ 
          api: { SDGameId: eventStats.game.id }
        },
        { 
          $set: 
            api: 
              SDGameId: eventStats.game.id
            sport: sport
            status: eventStats.game.status
            team: eventStats.game.team
            home: eventStats.game.home
            away: eventStats.game.away
        },
        { upsert: true }
      )
 
#   callGetStatsNFL: ->
#     timer = Meteor.setInterval callback, 1000

#   var dotime=function(){
#   var iv = setInterval(function(){
#     sys.puts("interval");
#   }, 1000);
#   return setTimeout(function(){
#     clearInterval(iv);
#   }, 5500);
# };

 # 2014 REG Schedule as an Array for populating EventStats collection 
nfl_2014_REG_schedule = [[1,"GB","SEA"]
[1,"NO","ATL"]
[1,"NE","MIA"]
[1,"JAC","PHI"]
[1,"OAK","NYJ"]
[1,"BUF","CHI"]
[1,"TEN","KC"]
[1,"CLE","PIT"]
[1,"WAS","HOU"]
[1,"CIN","BAL"]
[1,"MIN","STL"]
[1,"CAR","TB"]
[1,"SF","DAL"]
[1,"IND","DEN"]
[1,"NYG","DET"]
[1,"SD","ARI"]
[2,"PIT","BAL"]
[2,"DAL","TEN"]
[2,"DET","CAR"]
[2,"MIA","BUF"]
[2,"NE","MIN"]
[2,"NO","CLE"]
[2,"ATL","CIN"]
[2,"JAC","WAS"]
[2,"ARI","NYG"]
[2,"SEA","SD"]
[2,"STL","TB"]
[2,"HOU","OAK"]
[2,"NYJ","GB"]
[2,"KC","DEN"]
[2,"CHI","SF"]
[2,"PHI","IND"]
[3,"TB","ATL"]
[3,"GB","DET"]
[3,"TEN","CIN"]
[3,"DAL","STL"]
[3,"WAS","PHI"]
[3,"OAK","NE"]
[3,"HOU","NYG"]
[3,"SD","BUF"]
[3,"IND","JAC"]
[3,"MIN","NO"]
[3,"BAL","CLE"]
[3,"SF","ARI"]
[3,"KC","MIA"]
[3,"DEN","SEA"]
[3,"PIT","CAR"]
[3,"CHI","NYJ"]
[4,"NYG","WAS"]
[4,"BUF","HOU"]
[4,"TB","PIT"]
[4,"DET","NYJ"]
[4,"TEN","IND"]
[4,"CAR","BAL"]
[4,"GB","CHI"]
[4,"MIA","OAK"]
[4,"JAC","SD"]
[4,"ATL","MIN"]
[4,"PHI","SF"]
[4,"NO","DAL"]
[4,"NE","KC"]
[5,"MIN","GB"]
[5,"ATL","NYG"]
[5,"BAL","IND"]
[5,"HOU","DAL"]
[5,"STL","PHI"]
[5,"CLE","TEN"]
[5,"TB","NO"]
[5,"BUF","DET"]
[5,"CHI","CAR"]
[5,"PIT","JAC"]
[5,"ARI","DEN"]
[5,"KC","SF"]
[5,"NYJ","SD"]
[5,"CIN","NE"]
[5,"SEA","WAS"]
[6,"IND","HOU"]
[6,"PIT","CLE"]
[6,"DEN","NYJ"]
[6,"DET","MIN"]
[6,"GB","MIA"]
[6,"JAC","TEN"]
[6,"BAL","TB"]
[6,"NE","BUF"]
[6,"CAR","CIN"]
[6,"SD","OAK"]
[6,"DAL","SEA"]
[6,"CHI","ATL"]
[6,"WAS","ARI"]
[6,"NYG","PHI"]
[6,"SF","STL"]
[7,"NYJ","NE"]
[7,"TEN","WAS"]
[7,"SEA","STL"]
[7,"CIN","IND"]
[7,"MIA","CHI"]
[7,"CAR","GB"]
[7,"CLE","JAC"]
[7,"ATL","BAL"]
[7,"MIN","BUF"]
[7,"NO","DET"]
[7,"KC","SD"]
[7,"ARI","OAK"]
[7,"NYG","DAL"]
[7,"SF","DEN"]
[7,"HOU","PIT"]
[8,"SD","DEN"]
[8,"DET","ATL"]
[8,"BAL","CIN"]
[8,"BUF","NYJ"]
[8,"SEA","CAR"]
[8,"MIA","JAC"]
[8,"HOU","TEN"]
[8,"CHI","NE"]
[8,"STL","KC"]
[8,"MIN","TB"]
[8,"PHI","ARI"]
[8,"OAK","CLE"]
[8,"IND","PIT"]
[8,"GB","NO"]
[8,"WAS","DAL"]
[9,"NO","CAR"]
[9,"SD","MIA"]
[9,"ARI","DAL"]
[9,"WAS","MIN"]
[9,"PHI","HOU"]
[9,"JAC","CIN"]
[9,"TB","CLE"]
[9,"NYJ","KC"]
[9,"STL","SF"]
[9,"DEN","NE"]
[9,"OAK","SEA"]
[9,"BAL","PIT"]
[9,"IND","NYG"]
[10,"CLE","CIN"]
[10,"KC","BUF"]
[10,"DAL","JAC"]
[10,"PIT","NYJ"]
[10,"TEN","BAL"]
[10,"SF","NO"]
[10,"MIA","DET"]
[10,"ATL","TB"]
[10,"DEN","OAK"]
[10,"STL","ARI"]
[10,"NYG","SEA"]
[10,"CHI","GB"]
[10,"CAR","PHI"]
[11,"BUF","MIA"]
[11,"TB","WAS"]
[11,"MIN","CHI"]
[11,"ATL","CAR"]
[11,"HOU","CLE"]
[11,"CIN","NO"]
[11,"SEA","KC"]
[11,"SF","NYG"]
[11,"DEN","STL"]
[11,"OAK","SD"]
[11,"PHI","GB"]
[11,"DET","ARI"]
[11,"NE","IND"]
[11,"PIT","TEN"]
[12,"KC","OAK"]
[12,"TB","CHI"]
[12,"TEN","PHI"]
[12,"CLE","ATL"]
[12,"GB","MIN"]
[12,"CIN","HOU"]
[12,"DET","NE"]
[12,"JAC","IND"]
[12,"STL","SD"]
[12,"ARI","SEA"]
[12,"MIA","DEN"]
[12,"WAS","SF"]
[12,"DAL","NYG"]
[12,"NYJ","BUF"]
[12,"BAL","NO"]
[13,"CHI","DET"]
[13,"PHI","DAL"]
[13,"SEA","SF"]
[13,"NYG","JAC"]
[13,"TEN","HOU"]
[13,"NO","PIT"]
[13,"CLE","BUF"]
[13,"CAR","MIN"]
[13,"SD","BAL"]
[13,"CIN","TB"]
[13,"WAS","IND"]
[13,"OAK","STL"]
[13,"ARI","ATL"]
[13,"NE","GB"]
[13,"DEN","KC"]
[13,"MIA","NYJ"]
[14,"DAL","CHI"]
[14,"NYJ","MIN"]
[14,"CAR","NO"]
[14,"BAL","MIA"]
[14,"IND","CLE"]
[14,"STL","WAS"]
[14,"HOU","JAC"]
[14,"PIT","CIN"]
[14,"NYG","TEN"]
[14,"TB","DET"]
[14,"KC","ARI"]
[14,"BUF","DEN"]
[14,"SEA","PHI"]
[14,"SF","OAK"]
[14,"NE","SD"]
[14,"ATL","GB"]
[15,"ARI","STL"]
[15,"HOU","IND"]
[15,"OAK","KC"]
[15,"PIT","ATL"]
[15,"MIA","NE"]
[15,"WAS","NYG"]
[15,"CIN","CLE"]
[15,"GB","BUF"]
[15,"JAC","BAL"]
[15,"TB","CAR"]
[15,"DEN","SD"]
[15,"NYJ","TEN"]
[15,"MIN","DET"]
[15,"SF","SEA"]
[15,"DAL","PHI"]
[15,"NO","CHI"]
[16,"TEN","JAC"]
[16,"PHI","WAS"]
[16,"SD","SF"]
[16,"NE","NYJ"]
[16,"MIN","MIA"]
[16,"KC","PIT"]
[16,"BAL","HOU"]
[16,"CLE","CAR"]
[16,"DET","CHI"]
[16,"ATL","NO"]
[16,"GB","TB"]
[16,"NYG","STL"]
[16,"BUF","OAK"]
[16,"IND","DAL"]
[16,"SEA","ARI"]
[16,"DEN","CIN"]
[17,"NYJ","MIA"]
[17,"BUF","NE"]
[17,"JAC","HOU"]
[17,"CHI","MIN"]
[17,"NO","TB"]
[17,"IND","TEN"]
[17,"CLE","BAL"]
[17,"SD","KC"]
[17,"DAL","WAS"]
[17,"PHI","NYG"]
[17,"OAK","DEN"]
[17,"ARI","SF"]
[17,"DET","GB"]
[17,"CAR","ATL"]
[17,"STL","SEA"]
[17,"CIN","PIT"]]


# To access a new statistic, add the game to the Array below and ensure that the variable name is the same as in the Function below.
# nfl_2014_PST_schedule = [[2, 'IND', 'DEN'], [2, 'CAR', 'SEA'], [2, 'BAL', 'NE'], [2, 'DAL', 'GB']]
nfl_2014_PST_schedule = [[3, 'IND', 'NE']]
# PST
# how Meteor.setInterval works, the code is cracked!
# http://stackoverflow.com/questions/15229141/simple-timer-in-meteor-js
# 
i = 0 
len = nfl_2014_PST_schedule.length

callback = ->
  if nfl_2014_PST_schedule[i]
    console.log nfl_2014_PST_schedule[i][0], nfl_2014_PST_schedule[i][1], nfl_2014_PST_schedule[i][2]
    Meteor.call 'getEventStatsNFL', 'NFL', nfl_2014_PST_schedule[i][0], nfl_2014_PST_schedule[i][1], nfl_2014_PST_schedule[i][2]
    i++
  else
    Meteor.clearInterval timer

# TURN THIS ON TO SEE THE MAGIC
# timer = Meteor.setInterval callback, 1000