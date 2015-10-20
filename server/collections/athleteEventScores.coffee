Meteor.methods
  
  # Given a specific game, creates Scores for ALL players in the game.
  # STEP 1. Gets the athletes stats associated
  # STEP 2. Gets aggregated stats through pipeline
  # STEP 3. Stores them in a new AthleteEventScore Collection.
  # 
  # @param sdGameId [String] SportsData API Game Id 
  # @return [Doc] inserts the aggregated document into the collection
  # 
  batchAthleteEventScoringNFL: (sdGameId) ->
    # Step 1. find distinct athletes in the game, since there are multiple athlete records per NFL game
    SDathleteIds = Meteor.call '_getAthletes', sdGameId

    # Step 1A. Add in NFL defenses, by adding in distinct team_ids, ie. 'SEA', 'NE'
    # 
    event = Events.find({ 'api.SDGameId': sdGameId })
    SDathleteIds.push event.home
    SDathleteIds.push event.away

    # Step 2. gets aggregated stats per athlete per event
    # TODO: could create a new method from this
    aggregatedStats = []
    for athleteId in SDathleteIds
      aggregatedStats.push (Meteor.call '_getAggregateStats', athleteId, sdGameId)

    # Step 3. pushes them into a new Collection
    for newStat in aggregatedStats
      if newStat # take care of undefined
        AthleteEventScores.upsert(
          {
            "api.compoundId": newStat.api.compoundId
          }, 
          _.omit(newStat, '_id')
        )

  # Returns all unique athletes per event
  # 
  # @param sdGameId [String] SportsData API Game Id 
  # @return is an [Array] array of unique SD Player Ids in the game
  # 
  _getAthletes: (sdGameId) ->
    return AthleteEventStats.distinct( 'api.SDPlayerId', {'api.SDGameId': sdGameId } )

  # Aggregates player stats across statistical categories into one document 
  # This is mainly for NFL Stats, as for a given player (QB), there are 'passing', 'rushing' stats
  # 
  # @param sdPlayerId [String] SD Player Id 
  # @param sdGameId [String] SportsData API Game Id 
  # @return [Doc] the aggregated player document with all stats for a given game
  # 
  _getAggregateStats: (sdPlayerId, sdGameId) ->
    # TODO: IF this fails when there isn't yet a SCORE field... conditional if `score` field exists
    # then may need to copy this and do a check if they field exitsts....
    stats =  AthleteEventStats.aggregate([ 
      { $match: { "api.SDPlayerId": sdPlayerId, "api.SDGameId": sdGameId } },
      { $project: { _id: 0, "api.SDPlayerId": "$api.SDPlayerId", "api.SDGameId": "$api.SDGameId", "api.compoundId": {$concat: ["$api.SDPlayerId", "-", "$api.SDGameId"]}, status: 1, sport: 1, teamId: 1, "stats.statType": "$statType", "stats.stats": "$stats", full_name: 1, position: 1, score: 1 }}, 
      { $group: { _id: null, allStats: {$addToSet: "$stats"}, api: {$first: "$api"}, status: {$first: "$status"}, sport: {$first: "$sport"}, teamId: {$first: "$teamId"}, full_name: {$first: "$full_name"}, position: {$first: "$position"}, score: {$first: "$score"} } }
    ])

    return stats[0]
    
  # Add scores to each AthleteEventScore
  # Note: scores are multiplied by 100, to keep good javascript integers for the scores
  # 
  # TODO: add a dictionary of statType variables, for easy switching out of scoring styles...
  # ie: points = { rushing_yds = .1, ... }
  addScoreByGame: (sport, sdGameId) ->
    switch sport
      when 'NFL'
        Meteor.call 'addScoreByGameNFL', sdGameId
      when 'NBA'
        Meteor.call 'addScoreByGameNBA', sdGameId

  addScoreByGameNFL: (sdGameId) ->
    AthleteEventScores.find({ 'api.SDGameId': sdGameId }).forEach (doc) ->
      score = 0 # initialize scores
      for stat in doc.allStats
        switch stat.statType
          when 'rushing'
            score += stat.stats.yds * 10
          when 'passing'
            score += stat.stats.yds * 4
            score += stat.stats.td * 400
            score += stat.stats.int * -100
          when 'receiving'
            score += stat.stats.yds * 10
            score += stat.stats.rec * 50
          when 'touchdowns'
            score += stat.stats.pass * 600
            score += stat.stats.rush * 600
            score += stat.stats.int * 600 
            score += stat.stats.fum_ret * 600
            score += stat.stats.punt_ret * 600
            score += stat.stats.kick_ret * 600
            score += stat.stats.fg_ret * 600
            score += stat.stats.other * 600
          # TODO: Add when you know XXX
          # when 'two_point_conversion'
            # score += stat.stats.XXX
          when 'fumbles'
            score += stat.stats.lost * -200
            score += stat.stats.own_rec_td * 600
          when 'field_goal'
            score += stat.stats.made_19 * 300
            score += stat.stats.made_29 * 300
            score += stat.stats.made_39 * 300
            score += stat.stats.made_49 * 400
            score += stat.stats.made_50 * 500
          when 'extra_point'
            score += stat.stats.made * 100
          when 'defense' # DOUBLE CHECK THESE CATEGORIES ARE ALL COVERED
            score += stat.stats.sack * 100
            score += stat.stats.fum_rec * 200
            score += stat.stats.int * 200
            score += stat.stats.int_td * 600
            score += stat.stats.fum_td * 600

      AthleteEventScores.update(
        { _id: doc._id } # update itself
        { $set: { score: score }}
      )

  addScoreByGameNBA: (sdGameId) ->
    AthleteEventScores.find({ 'api.SDGameId': sdGameId }).forEach (doc) ->
      score = 0 # initialize scores
      stat = doc.stats

      # 1. Start Scoring, remember 1 reallife point = 100 db points
      score += stat.points * 100
      score += stat.three_points_made * 50
      score += stat.rebounds * 125
      score += stat.assists * 150
      score += stat.turnovers * -50
      score += stat.steals * 200
      score += stat.blocks * 200

      # 2. Calculate Double Double or Triple Double
      doubleDouble = false
      tripleDouble = false

      tenSpot = 0
      for type in ['points', 'rebounds', 'assists', 'blocks', 'steals']
        tenSpot += 1 if stat[type] >= 10
        if tenSpot >= 2 then doubleDouble = true
        if tenSpot >= 3 then tripleDouble = true

      score += 150 if doubleDouble
      score += 300 if tripleDouble

      # 3. Update document!
      AthleteEventScores.update(
        { _id: doc._id } # update itself
        { $set: { score: score }}
      )

Meteor.call 'batchAthleteEventScoringNFL', "c7c45e93-5d60-4389-84e1-971c8ce8807e"
Meteor.call 'addScoreByGameNFL', "c7c45e93-5d60-4389-84e1-971c8ce8807e"