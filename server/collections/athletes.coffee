teams = [ 'TEN',
'BUF',
'MIA',
'NYJ',
'NE',
'CIN',
'CLE',
'BAL',
'PIT',
'IND',
'JAC'
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
    console.log 'we are running this', team
    roster = sd.NFLApi.getTeamRoster team
    players = roster.team.player

    # console.log roster
    for player in players
      # if player exists already
      existingPlayer = NflPlayers.findOne({ "full_name": player.$.name_full })
      if existingPlayer
        # add the id to the player
        NflPlayers.update({ espn_id: existingPlayer.espn_id },
          { $set: { api: { SDPlayerId: player.$.id }} }
        )
      else # if player doesn't exist, insert him
        NflPlayers.insert({
          full_name: player.$.name_full
          first_name: player.$.name_first
          last_name: player.$.name_last
          jersey_number: player.$.jersey_number
          position: player.$.position
          team: roster.team.$.market + ' ' + roster.team.$.name
          api: {
            SDPlayerId: player.$.id
          }
        })

        console.log 'new player', player.$.name_full, ' ', roster.team.$.market

# THIS SET OF TIMED CALLS WORKS
# Meteor.call 'getAthletesNFL', 'TEN'
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'BUF')
#   , 5000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'MIA')
#   , 10000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'NYJ')
#   , 15000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'NE')
#   , 20000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'CIN')
#   , 25000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'CLE')
#   , 30000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'BAL')
#   , 35000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'PIT')
#   , 40000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'IND')
#   , 45000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'JAC')
#   , 50000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'HOU')
#   , 55000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'DEN')
#   , 60000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'SD')
#   , 65000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'KC')
#   , 70000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'OAK')
#   , 75000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'DAL')
#   , 80000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'PHI')
#   , 85000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'NYG')
#   , 90000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'WAS')
#   , 95000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'CHI')
#   , 100000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'DET')
#   , 105000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'GB')
#   , 110000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'MIN')
#   , 115000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'TB')
#   , 120000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'ATL')
#   , 125000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'CAR')
#   , 130000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'NO')
#   , 135000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'SF')
#   , 140000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'ARI')
#   , 145000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'STL')
#   , 150000)
# Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', 'SEA')
#   , 155000)

# THIS SET TIMEOUT FUNCTION DOENS"T WORK SINCE TEAM is last - Must use closure
#   getAthletesAllTeams: ->
#     for team, i in teams
#       console.log 'GO!', team
#       Meteor.setTimeout((team) ->
#         Meteor.call('getAthletesNFL', team)
#       , i * 5000)   

# Meteor.call 'getAthletesAllTeams'

# for team, i in teams
#   console.log 'GO!', team
#   Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', team)
#   , i * 5000)

# EXAMPLE via SD API: player.$
#     { id: '6eba2319-7d5b-44da-bc48-280d3f9e423f',
#       name_full: 'Lorenzo Taliaferro',
#       name_first: 'Lorenzo',
#       name_last: 'Taliaferro',
#       name_abbr: 'L.Taliaferro',
#       birthdate: '',
#       birth_place: 'Yorktown, VA',
#       high_school: 'Bruton High School',
#       height: '74',
#       weight: '226',
#       college: 'Coastal Carolina',
#       position: 'RB',
#       jersey_number: '34',
#       status: 'IR',
#       salary: '0',
#       experience: '0',
#       draft_pick: '138',
#       draft_round: '4',
#       draft_team: 'BAL' }
