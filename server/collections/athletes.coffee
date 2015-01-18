nflTeams = [ 'TEN',
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

playoffTeams = ['NE', 'SEA', 'GB', 'IND']

Meteor.methods

  # This method adds the SD Player Id to the existing player's object.
  # This method initially was for adding Data to Seed Data
  # There are a few scenarios: 
  # 1) new player
  # 2) existing player, new information (team change, most likely)
  # 3) duplicate name, yet different player. (difficult, may need to add other identifer on there - jersey-team-last-name)
  # If the athlete doesn't exist yet, it adds them.
  getAthletes: (sport, team) ->
    console.log '------------- UPDATING ATHLETE ', sport, ' ROSTERS -------------'
    console.log '-------------', team, '-------------'
    roster = sd.NFLApi.getTeamRoster team
    players = roster.team.player
    console.log players

    for player in players
      # if player exists already, 
      # TODO: This leaves a number of players without matching names WITHOUT api.SDPlayerIds
      existingPlayer = NflPlayers.findOne({ "full_name": player.name_full })
      if existingPlayer
        # add the id to the player
        # TODO: full_name isn't the most unique identifier
        if !existingPlayer.api and !existingPlayer.SDPlayerId
          NflPlayers.update(
            { full_name: existingPlayer.full_name },
            { $set: { "api.SDPlayerId": player.id } }
          )
          console.log player
          console.log 'existing player: added SD player Id to ', player.name_full, ' ', player.position
        
      else # if athlete doesn't exist, insert him
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

        console.log 'new player', player.name_full, ' ', roster.team.market, ' ', player.position

# Meteor.setInterval works, the code is cracked!
# http://stackoverflow.com/questions/15229141/simple-timer-in-meteor-js
# 
i = 0
len = playoffTeams.length

callback = ->
  if i is len
    Meteor.clearInterval timer
  else
    Meteor.call 'getAthletes', 'NFL', playoffTeams[i]
    i++
    
# TURN THIS ON TO SEE THE MAGIC
# timer = Meteor.setInterval callback, 8000
