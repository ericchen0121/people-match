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
# 'BUF',
# 'MIA',
# 'NYJ',
# 'NE',
# 'CIN',
# 'CLE',
# 'BAL',
# 'PIT',
# 'IND',
# 'JAC'
# 'HOU',
# 'DEN',
# 'SD',
# 'KC',
# 'OAK',
# 'DAL',
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
# 'ARI',
# 'STL',
# 'SEA'
]

# Meteor.call 'getAthletesNFL', 'TEN'

# for team, i in teams
#   console.log 'GO!', team
#   Meteor.setTimeout( () ->
#     Meteor.call('getAthletesNFL', team)
#   , i * 5000)

# EXAMPLE player.$
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
# {
#       "espn_id" : 15091,
#       "full_name" : "Randy Bullock",
#       "first_name" : "Randy",
#       "last_name" : "Bullock",
#       "jersey_number" : 4,
#       "position" : "PK",
#       "team" : "Houston Texans",
#       "kimono_hash" : "724483d2d69b96b5aea4902f25f24f7d",
#       "kimono_api" : "7gtzc33a",
#       "_id" : ObjectId("5473d023f7222d6660eebe16")
