nfl_team_ids = [ 'TEN',
'BUF',
'MIA',
'NYJ',
'NE',
'CIN',
'CLE',
'BAL',
'PIT',
'IND',
'JAC',
'HOU',
'DEN',
'SD',
'KC',
'OAK',
'DAL',
'PHI',
'NYG',
'WAS',
'CHI',
'DET',
'GB',
'MIN',
'TB',
'ATL',
'CAR',
'NO',
'SF',
'ARI',
'STL',
'SEA'
]

Meteor.methods

  # This method adds the SD Player Id to the existing player's object.
  # If the athlete doesn't exist yet, it adds them.
  getAthletesNFL: (team) ->
    console.log '-------------', team, '-------------'
    roster = sd.NFLApi.getTeamRoster team
    players = roster.team.player

    for player in players
      # if player exists already
      existingPlayer = NflPlayers.findOne({ "full_name": player.name_full })
      if existingPlayer
        # add the id to the player
        NflPlayers.update({ espn_id: existingPlayer.espn_id },
          { $set: { api: { SDPlayerId: player.id }} }
        )
      else # if player doesn't exist, insert him
        NflPlayers.insert({
          full_name: player.name_full
          first_name: player.name_first
          last_name: player.name_last
          jersey_number: player.jersey_number
          position: player.position
          team: roster.team.market + ' ' + roster.team.name
          team_id: roster.team.id
          api: {
            SDPlayerId: player.id
          }
        })

        console.log 'new player', player.name_full, ' ', roster.team.market

# Meteor.setInterval works, the code is cracked!
# http://stackoverflow.com/questions/15229141/simple-timer-in-meteor-js
# 
i = 0
len = nfl_team_ids.length

callback = ->
  if i is len
    Meteor.clearInterval timer
  else
    Meteor.call 'getAthletesNFL', nfl_team_ids[i]
    i++
# TURN THIS ON TO SEE THE MAGIC
# timer = Meteor.setInterval callback, 5000
