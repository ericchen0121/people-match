Meteor.methods

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
      else
        NflPlayers.insert({
          full_name: player.$.name_full
          first_name: player.$.name_first
          last_name: player.$.name_last
          jersey_number: player.$.jersey_number
          position: player.$.position
          team: roster.team.$.market + ' ' + roster.team.$.name
        })

        console.log 'new player', player.$.name_full, ' ', roster.team.$.market

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

# CALLED THIS FUNCTION ONCE FOR EVERY TEAM
# and restarted the meteor server each time to update all teams
# Meteor.call 'getAthletesNFL', 'TEN'

# THIS SET TIMEOUT FUNCTION DOENS"T WORK SINCE TEAM is last - Must use closure
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

# NFL PLAYER SCHEMA
# { "_id" : ObjectId("5473d022f7222d6660eebb84"),
# "api" : { "SDPlayerId" : "c5dfc54e-fd64-468f-81a8-073918776412" },
# "espn_id" : 14891,
# "first_name" : "Bernard",
# "full_name" : "Bernard Pierce",
# "jersey_number" : 30,
# "kimono_api" : "7gtzc33a",
# "kimono_hash" : "0d4b9044c1fae82efde643e073d95389",
# "last_name" : "Pierce",
# "position" : "RB",
# "team" : "Baltimore Ravens" }
