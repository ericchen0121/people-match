Meteor.methods

# TODO: Can create a global key/value and call all of them in one loop here.
  addTeamIdsToPlayers: ->
    NflPlayers.update({team: "Tennessee Titans"}, {$set: {"team_id": "TEN"}}, {multi: true})
    NflPlayers.update({team: "Buffalo Bills"}, {$set: {"team_id": "BUF"}}, {multi: true})
    NflPlayers.update({team: "Miami Dolphins"}, {$set: {"team_id": "MIA"}}, {multi: true})
    NflPlayers.update({team: "New York Jets"}, {$set: {"team_id": "NYJ"}}, {multi: true})
    NflPlayers.update({team: "New England Patriots"}, {$set: {"team_id": "NE"}}, {multi: true})
    NflPlayers.update({team: "Cincinnati Bengals"}, {$set: {"team_id": "CIN"}}, {multi: true})
    NflPlayers.update({team: "Cleveland Browns"}, {$set: {"team_id": "CLE"}}, {multi: true})
    NflPlayers.update({team: "Baltimore Ravens"}, {$set: {"team_id": "BAL"}}, {multi: true})
    NflPlayers.update({team: "Pittsburgh Steelers"}, {$set: {"team_id": "PIT"}}, {multi: true})
    NflPlayers.update({team: "Indianapolis Colts"}, {$set: {"team_id": "IND"}}, {multi: true})
    NflPlayers.update({team: "Jacksonville Jaguars"}, {$set: {"team_id": "JAC"}}, {multi: true})
    NflPlayers.update({team: "Houston Texans"}, {$set: {"team_id": "HOU"}}, {multi: true})
    NflPlayers.update({team: "Denver Broncos"}, {$set: {"team_id": "DEN"}}, {multi: true})
    NflPlayers.update({team: "San Diego Chargers"}, {$set: {"team_id": "SD"}}, {multi: true})
    NflPlayers.update({team: "Kansas City Chiefs"}, {$set: {"team_id": "KC"}}, {multi: true})
    NflPlayers.update({team: "Oakland Raiders"}, {$set: {"team_id": "OAK"}}, {multi: true})
    NflPlayers.update({team: "Dallas Cowboys"}, {$set: {"team_id": "DAL"}}, {multi: true})
    NflPlayers.update({team: "Philadelphia Eagles"}, {$set: {"team_id": "PHI"}}, {multi: true})
    NflPlayers.update({team: "New York Giants"}, {$set: {"team_id": "NYG"}}, {multi: true})
    NflPlayers.update({team: "Washington Redskins"}, {$set: {"team_id": "WAS"}}, {multi: true})
    NflPlayers.update({team: "Chicago Bears"}, {$set: {"team_id": "CHI"}}, {multi: true})
    NflPlayers.update({team: "Detroit Lions"}, {$set: {"team_id": "DET"}}, {multi: true})
    NflPlayers.update({team: "Green Bay Packers"}, {$set: {"team_id": "GB"}}, {multi: true})
    NflPlayers.update({team: "Minnesota Vikings"}, {$set: {"team_id": "MIN"}}, {multi: true})
    NflPlayers.update({team: "Tampa Bay Buccaneers"}, {$set: {"team_id": "TB"}}, {multi: true})
    NflPlayers.update({team: "Atlanta Falcons"}, {$set: {"team_id": "ATL"}}, {multi: true})
    NflPlayers.update({team: "Carolina Panthers"}, {$set: {"team_id": "CAR"}}, {multi: true})
    NflPlayers.update({team: "New Orleans Saints"}, {$set: {"team_id": "NO"}}, {multi: true})
    NflPlayers.update({team: "San Francisco 49ers"}, {$set: {"team_id": "SF"}}, {multi: true})
    NflPlayers.update({team: "Arizona Cardinals"}, {$set: {"team_id": "ARI"}}, {multi: true})
    NflPlayers.update({team: "St. Louis Rams"}, {$set: {"team_id": "STL"}}, {multi: true})
    NflPlayers.update({team: "Seattle Seahawks"}, {$set: {"team_id": "SEA"}}, {multi: true})

  # Adds a base salary of 4500 to all players, which powers the contest.
  addSalary: ->
    NflPlayers.update(
      {}, 
      { $set: { salary: 4500 }}
      { multi: true}
    )

# TODO: Create a frontend UI to call this method 
# Meteor.call("addTeamIdsToPlayers")
