# ARCHITECTURE NOTES: 
# -We have architected this pipeline leg around the status of an Event Stat (which comes from Events)
# being in a certain state ("inprogress", as given by SD API). 
# -We could run this off the api.SDGameId as well or some other identifier we would create on 
# the collections: eventId: NFL_2014_PST_3_IND_NE
# 
# POTENTIAL TODO: Rewrite these methods in the aggregate framwork. Examples in athleteEventStats2.coffee.
# 
Meteor.methods

  # INPUT: asks for a sport's 'inprogress' status. 
  # OUTPUT: returns distinct ids  of games with that status
  _getAthleteEventStats: (sport, status) ->
    EventStats.distinct('_id', { sport: sport, status: status })

  # @param SDGameId [string] the SportsData API's game id
  # 
  convertToAthleteEventStatsNFL: (SDGameId) ->
    # STEP 1: Find existing Event Stat
    eventStat = EventStats.findOne({api: { SDGameId: SDGameId }})

    # STEP 2: Begin creating the new AthleteEventStat
    newStat = {}

    newStat.api = eventStat.api # API id for event
    newStat.status = eventStat.status
    newStat.sport = 'NFL'
    newStat.stats = {}
    # TODO: add `game id: '2014_PST_1_BAL_PIT'` in a standard query format for 'easy intuitive querying'

    # STEP 3: Parse over the EventStat to get to the data
    # parse each of the two teams in the array
    for team in eventStat.team
      newStat.teamId = team.id

      # Create a new AthleteEventStat doc for each player in the EventStat for each 
      # statistical category of relevance
      statTypes = ['rushing', 'passing', 'receiving', 'touchdowns', 'two_point_conversion', 'extra_point', 'fumbles', 'field_goal']

      # STEP 3A: Parse over each stat type to get to the data
      for statType in statTypes
        if team[statType] # if it exists... in the middle of a game it may not exist
          
          playerStats = team[statType]['player']
          # ensure it's an array before iterating over it
          if !Array.isArray(playerStats)
            playerStats = [playerStats]

          # STEP 4: Parse over each player data to get to individual player stat
          # iterate over the array.
          # TODO: Fix the "api.SDGameId" key that is created.
          for stat in playerStats
            if stat # in case stat is 'undefined'
              newStat.statType = statType 
              newStat.api.SDPlayerId = stat.id
              newStat.full_name = stat.name
              newStat.position = stat.position
              newStat.stats = _.omit(stat, ['id', 'name', 'jersey', 'position']) # remove redundant ID, remove all strings

            # STEP 4A: Clean XML Data (to deprecate!)
            # convert xml strings to integers.
            for k,v of newStat.stats
              newStat.stats[k] = parseInt(v)

            # STEP 5: Upsert each into the collection
            newStat.api.compoundId = newStat.api.SDGameId + '-' + newStat.api.SDPlayerId + '-' + statType # unique id
            AthleteEventStats.upsert(
              { "api.compoundId": newStat.api.compoundId }, 
              newStat
            )

    # DEFENSE is easier to deal with separately.
    # defense ONLY STORES team defense stats at this time
    for team in eventStat.team
      newStat = {}
      newStat.statType = 'defense'
      newStat.api = eventStat.api # API id for event
      newStat.api.SDPlayerId = team.id
      newStat.teamId = team.id
      newStat.status = eventStat.status
      newStat.sport = 'NFL'
      newStat.stats = {}
      newStat.stats = _.omit(team.defense, 'player') # remove entire player array, only keeping team stats

      # STEP 4A: Clean XML Data (to deprecate!)
      # convert xml strings to integers bam
      for k,v of newStat.stats
        newStat.stats[k] = parseInt(v)

      # STEP 5: Upsert each into the collection
      newStat.api.compoundId = newStat.api.SDGameId + '-' + newStat.api.SDPlayerId + '-' +  newStat.statType
      AthleteEventStats.upsert(
        { "api.compoundId": newStat.api.compoundId }, 
        newStat
      )

  convertToAthleteEventStatsNBA: (SDGameId) ->
    # STEP 1: Find existing Event Stat
    eventStat = EventStats.findOne({api: { SDGameId: SDGameId }})

    # STEP 2: Begin creating the new AthleteEventStat
    newStat = {}

    newStat.api = eventStat.api # API id for event
    newStat.status = eventStat.status
    newStat.sport = 'NBA'
    newStat.stats = {}

    # STEP 3: Parse over the EventStat to get to the data
    for team in [ eventStat.home, eventStat.away ]
      newStat.teamId = team.market # Meteor.call 'teamAbbreviationNBA', eventStat.market

      # STEP 4: Parse over each player data to get to individual player stat
      for player in team.players

        player_pared = _.omit(player, 'first_name', 'last_name') 

        # Copy all key-value pairs over
        _.each player_pared, (v, k) ->
          if k == 'id'
            newStat.api.SDPlayerId = v # store all SD info in api key
          else if k == 'statistics'
            newStat['stats'] = v # rename to 'stats' to be consistent with NFL
          else
            newStat[k] = v # else keep what the API gives
        
        # STEP 5: Upsert each into the collection
        AthleteEventStats.upsert(
          { 
            "api.SDGameId": newStat.api.SDGameId
            "api.SDPlayerId": newStat.api.SDPlayerId
          }, 
          newStat
        )

        #STEP 6. Copy into Scores collection as well.
        AthleteEventScores.upsert(
          { 
            "api.SDGameId": newStat.api.SDGameId
            "api.SDPlayerId": newStat.api.SDPlayerId
          }, 
          newStat
        )
  # @param market [String] the team's market, or city, name. ie. 'Minnesota'
  # @return [String] the team abbreviation, ie. 'MIN'
  # 
  # teamAbbreviationNBA: (market) ->



