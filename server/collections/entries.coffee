# Collection-hooks adds attributes before Entries.insert(entry)

Entries.before.insert (userId, doc) ->
  doc.createdAt = doc.createdAt || new Date().toISOString()
  doc.updatedAt = new Date().toISOString()
  doc.userId = userId

  # adds array of event api ids to the Entry
  contest = Contests.findOne({ _id: doc.contestId })
  doc.api ?= {} # don't overwrite existing api obj if it already exists
  eventIds = (id for {'api.SDGameId': id } in contest.fixture.events)
  console.log eventIds
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
  # NOTE: This potentially long term will be an expensive operation
  addTotalScoreAllEntries: (sdGameId) ->
    # iterate over the mongodb collection cursor
    # http://docs.mongodb.org/manual/reference/method/cursor.forEach/
    # 'api.SDGameIds' is an array, which should contain the sdGameId
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

  # TODO: At the end reconciliation of the Entry, 
  # Add scores for each player (Or reactively join) 

