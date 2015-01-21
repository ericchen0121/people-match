# Collection-hooks adds attributes before Entries.insert(entry)

Entries.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updatedAt = Date.now()
  doc.userId = userId

  # adds array of event api ids to the Entry
  contest = Contests.findOne({_id: doc.contestId})
  doc.api ?= {} # don't overwrite existing api obj if it already exists
  eventIds = (id for {api: {SDGameId: id}} in contest.fixture.events)
  doc.api.SDGameIds = eventIds

# Entries.before.update (userId, doc) ->
#   doc.updatedAt = Date.now()
#   doc.status = doc.status
 
Meteor.methods
  entryCreate: (entry) ->
    # update the contest with the number of entries
    Contests.update(entry.contestId, { $inc: { entryCount: 1 } } ) # this doesn't have the true count if entries are deleted
    Entries.insert(entry)

  # entryUpdateScoreLive: (entryId) ->
  # #   # Find the entry "pzfPTTEb6AW9cnp7q"
  #   Entries.findOne({ _id: "pzfPTTEb6AW9cnp7q" })
  #   # Get the Players associated with it
    
  #   # AGGREGATE QUERY
  #   ATHLETEEVENTSTATS.AGGREGATE(EntryId) ->


  # Once entries for the day are completed... update all entries one last time.
  entryUpdateComplete: ->
