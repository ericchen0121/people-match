# Collection-hooks adds attributes before Entries.insert(entry)

Entries.before.insert (userId, doc) ->
  doc.createdAt = doc.createdAt || new Date().toISOString()
  doc.updatedAt = new Date().toISOString()
  doc.userId = userId

  # adds array of event api ids to the Entry
  contest = Contests.findOne({_id: doc.contestId})
  doc.api ?= {} # don't overwrite existing api obj if it already exists
  eventIds = (id for {api: {SDGameId: id}} in contest.fixture.events)
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
    Contests.update(entry.contestId, { $inc: { entryCount: 1 } } ) # this doesn't have the true count if entries are deleted
    Entries.insert(entry)

  # TODO: This potentially long term will be an expensive operation
  entryUpdateScoreLive: (entryId) ->
    entry = Entries.findOne({ _id: entryId })
    
    # limit the search to players and games on the entry
    # Use `_id: null` for accumulated values in the $group stage
    result = AthleteEventScores.aggregate([
      { $match: {"api.SDPlayerId": { $in: entry.api.SDPlayerIds }, "api.SDGameId": { $in: entry.api.SDGameIds}}},
      { $group: { _id: null, totalScore: { $sum: "$score" } }}
    ])

    console.log 'the result!!!', result 

    Entries.update(
      { _id: entryId }
      { $set: { totalScore: result[0].totalScore }} 
    )

  # TODO: At the end reconciliation of the Entry, 
  # Add scores for each player (Or reactively join) 

# Meteor.call 'entryUpdateScoreLive', "HjiiRzfB8zah8AhfD"

