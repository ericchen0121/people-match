# Collection-hooks adds attributes before Entries.insert(entry)

Entries.before.insert (userId, doc) ->
  doc.createdAt = doc.createdAt || new Date().toISOString()
  doc.updatedAt = new Date().toISOString()
  doc.userId = userId
  doc.api ?= {} # don't overwrite existing api obj if it already exists

  # Store SDGameIds on Entry
  contest = Contests.findOne({ _id: doc.contestId })
  eventIds = []
  for event in contest.fixture.events
    eventIds.push event.api.SDGameId

  doc.api.SDGameIds = eventIds

  # initialize score
  doc.totalScore = 0

# https://github.com/matb33/meteor-collection-hooks#beforeupdateuserid-doc-fieldnames-modifier-options
Entries.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set.createdAt = modifier.$set.createdAt || new Date().toISOString()
  modifier.$set.updatedAt = new Date().toISOString()

Meteor.methods
  entryCreate: (entry) ->
    # update the contest with the number of entries
    Contests.update(entry.contestId, { $inc: { entryCount: 1 } } ) # TODO: this is not reactive
    Entries.insert(entry)

  # iterate over all entries with a given contest (identifed by a sdGameId)
  # NOTE: This potentially long term will be an expensive operation, ie. if there are 90,000 entries on a game
  addTotalScoreAllEntries: (sdGameId) ->
    # iterate over the mongodb collection cursor
    # http://docs.mongodb.org/manual/reference/method/cursor.forEach/
    # 'api.SDGameIds' is an array, in which one value is sdGameId
    # 
    Entries.find({'api.SDGameIds': sdGameId }).forEach (entry) ->
      Meteor.call 'addTotalScoreEntry', entry

  # input: takes an entry document
  # result: 
  # 
  addTotalScoreEntry: (entry) ->
    # match players and games from the entry's array
    # Use `_id: null` to get accumulated values in the $group stage
    # 
    result = AthleteEventScores.aggregate([
      { $match: {'api.SDPlayerId': { $in: entry.api.SDPlayerIds }, 'api.SDGameId': { $in: entry.api.SDGameIds}}},
      { $group: { _id: null, totalScore: { $sum: '$score' }, status: {$first: '$status' } }}
    ])

    resultDoc = result[0]

    if resultDoc && resultDoc.totalScore && resultDoc.status
      Entries.update(
        { _id: entry._id }
        { $set: 
          { 
            totalScore: resultDoc.totalScore, 
            status: resultDoc.status
          }
        } 
      )

  # Input: contestId, as all Entries are related to one Contest
  # Output: ranks all entries (on 'rank' attribute) according to their score rank
#   addRankToEntry: (contestId) ->
#     result = Entries.aggregate([
#       { $match: { contestId: contestId }}, 
#       { $project: { totalScore: 1 }}
#     ])

#     console.log 'the result is ', result 

#     for scoreDoc in result
#       rankDoc = Entries.aggregate([
#         { $match: { contestId: contestId, totalScore: { $gt: scoreDoc.totalScore } }}, 
#         { $group: { _id: 1, rank: {$sum: 1}} }
#       ])

#       console.log rankDoc
# Meteor.call 'addRankToEntry', 'KDFPHF5vJygCzWHGj'

  # Note: this is a helper for use with rankEntries, since we are feeding in a sdGameId/Event. However, rankEntries
  # works on contests. 

  rankContestsForEvent: (sdGameId) ->
    contestIds = Meteor.call 'distinctContestsForEvent', sdGameId
    
    for contestId in contestIds
      Meteor.call 'rankEntries', contestId

  distinctContestsForEvent: (sdGameId) ->
    Entries.distinct( 'contestId', {'api.SDGameIds': sdGameId } )

  # input: contestId, which is associated to entries
  # output: a 'rank' attribute on all associated entries with a number ranking their totalScore
  # method: uses Aggregation pipeline to rank, then uses an array to loop thru and update entries
  # todo/methodology: looked into doing this all in one go in Aggregation pipeline but spent too 
  # much time and couldn't do it in one query. Ultimately instead of two queries and still not having 
  # the result (see addRankToEntry method above), decided to move on.
  # 
  rankEntries: (contestId) ->
    result = Entries.aggregate([
      { $match: { contestId: contestId }}, 
      { $project: { totalScore: 1 }}, 
      { $sort: { totalScore: -1 }}
    ])

    for doc, i in result
      Entries.update(
        { _id: doc._id },
        { $set: { rank: i + 1 }}
      )

# Meteor.call 'rankEntries', 'KDFPHF5vJygCzWHGj'
  
  # TODO: At the end reconciliation of the Entry, 
  # Add scores for each player (Or reactively join) 
