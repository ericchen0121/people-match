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

  # NOTE: This potentially long term will be an expensive operation
  # TODO: create a way to score entries from a Contest
  # Instead of scoring each individual entryId, I need to score all entries with a Contest
  
  updateEntriesForContest: (sdGameId) ->
    console.log 'UPDATE ENTRIES FOR CONTEST'
    # iterate over the mongodb collection cursor
    # http://docs.mongodb.org/manual/reference/method/cursor.forEach/
    Entries.find({ 'api.SDGameIds': sdGameId }).forEach (entry) ->
      Meteor.call 'entryUpdateScoreLiveOne', entry


  entryUpdateScoreLive: (entryId) ->
    entry = Entries.findOne({ _id: entryId })
    
    # aggregate all scores for all the players in the game on the entry.
    # limit the search to players and games on the entry
    # Use `_id: null` for accumulated values in the $group stage
    # 
    result = AthleteEventScores.aggregate([
      { $match: {'api.SDPlayerId': { $in: entry.api.SDPlayerIds }, 'api.SDGameId': { $in: entry.api.SDGameIds}}},
      { $group: { _id: null, totalScore: { $sum: '$score' }, status: {$first: '$status' } }}
    ])

    resultDoc = result[0]

    if resultDoc.totalScore && resultDoc.status
      Entries.update(
        { _id: entryId }
        { $set: 
          { 
            totalScore: resultDoc.totalScore, 
            status: resultDoc.status
          }
        } 
      )

  entryUpdateScoreLiveOne: (entry) ->
    # aggregate all scores for all the players in the game on the entry.
    # limit the search to players and games on the entry
    # Use `_id: null` for accumulated values in the $group stage
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

# Meteor.call 'entryUpdateScoreLive', "HjiiRzfB8zah8AhfD"

