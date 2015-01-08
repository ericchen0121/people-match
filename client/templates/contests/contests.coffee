# The Contest Page adding Player to lineups/Rosters Functionality
# Currently the implementation stores a NflPlayer object in a Session json variable
# This variable looks like: { QB: [obj], RB1: [obj], WR1: [obj], WR2: 'open'} // 'open' if roster spot is open.
# All are reset to 'open' on hot code pushes.
#
# NOTE: We should persist this roster somehow and/or do checks if a user leaves a contest page
# or submits after a contest is filled up, and wants to remember his lineup.
addPlayerToRoster = (player) ->
  currentRoster = Session.getJSON 'currentLineup.roster'

  switch player.position
    when 'QB'
      if currentRoster['QB'] is 'open' then Session.setJSON 'currentLineup.roster.QB', player else alert 'QBs are Full'
    when 'RB'
      if currentRoster['RB1'] is 'open'
        Session.setJSON 'currentLineup.roster.RB1', player
      else if currentRoster['RB2'] is 'open'
        Session.setJSON 'currentLineup.roster.RB2', player
      else if currentRoster['FLEX1'] is 'open'
        Session.setJSON 'currentLineup.roster.FLEX1', player
      else if currentRoster['FLEX2'] is 'open'
        Session.setJSON 'currentLineup.roster.FLEX2', player
      else alert 'RBs are Full'
    when 'WR'
      if currentRoster['WR1'] is 'open'
        Session.setJSON 'currentLineup.roster.WR1', player
      else if currentRoster['WR2'] is 'open'
        Session.setJSON 'currentLineup.roster.WR2', player
      else if currentRoster['WR3'] is 'open'
        Session.setJSON 'currentLineup.roster.WR3', player
      else if currentRoster['FLEX1'] is 'open'
        Session.setJSON 'currentLineup.roster.FLEX1', player
      else if currentRoster['FLEX2'] is 'open'
        Session.setJSON 'currentLineup.roster.FLEX2', player
      else alert 'WRs are Full'
    when 'TE'
      if currentRoster['TE'] is 'open'
        Session.setJSON 'currentLineup.roster.TE', player
      else if currentRoster['FLEX1'] is 'open'
        Session.setJSON 'currentLineup.roster.FLEX1', player
      else if currentRoster['FLEX2'] is 'open'
        Session.setJSON 'currentLineup.roster.FLEX2', player
      else alert 'TEs are Full'
    when 'PK'
      if currentRoster['K'] is 'open' then Session.setJSON 'currentLineup.roster.K', player else alert 'Ks are Full'
    when 'DEF'
      if currentRoster['DEF'] is 'open' then Session.setJSON 'currentLineup.roster.DEF', player else alert 'DEFs are Full'

  # console.log Session.getJSON("currentLineup.roster")

validateEntry = () ->
  rosterJSON = Session.getJSON 'currentLineup.roster'
  valid = true # assume contest entry is true until proven false ;)

  $.each rosterJSON, (k, v) =>
    if v == 'open' || v._id == undefined
      valid = false
      return false # break out of $.each loop

  return valid

# Returns a list of all teams based on the Contest's Fixture Events
# QUESTION: Why does this calculate three times?
availableTeams = (contest) ->
  # events is an array of Event objects
  events = contest.fixture.events
  teams = []
  for event in events
    # provide a if/switch statement here in case schema of Event changes per sport
    if event.sport == 'NFL'
    # Assumes the Event object includes two teams like this: { ..
    # "home" : "JAC",
    # "away" : "TEN",
    # ..}
      teams.push event.home
      teams.push event.away

  return teams

Template.contestLineupContainer.helpers

  availablePlayers: ->
    position_filter = Session.getJSON 'playerListFilter.position'
    selectedTeamFilter = Session.getJSON "playerListFilter.teams"
    team_filter = if selectedTeamFilter? then selectedTeamFilter else availableTeams(@)
    switch position_filter
      when 'All'
        NflPlayers.find({ team_id: {$in: team_filter }, position: {$in: ['QB', 'RB', 'FB', 'WR', 'TE', 'PK']} })
      when 'K' # edge case when filter won't match position name
        NflPlayers.find({ team_id: {$in: team_filter }, position: 'PK' })
      # when 'D'
         # NflPlayers.find({ position: 'DEF' })
      else
        # http://stackoverflow.com/questions/19019822/how-do-i-access-one-sibling-variable-in-a-meteor-template-helper-when-i-am-in
        # assumed data context (ie. what @ is) is the Contest
        NflPlayers.find({ position: position_filter, team_id: {$in: team_filter }})

  salaryRemaining: ->
    60000

  salaryRemainingAvg: ->
    60000 / 12

  # Generates the Lineup View based on Session Data.
  # returns: [Array] of Athlete Objects
  currentLineup: ->

    # { 'QB': 'open', 'RB': object }
    rosterJSON = Session.getJSON 'currentLineup.roster'

    # convert the JSON form into an array for template iteration
    rosterArray = []

    if rosterJSON
      $.each rosterJSON, (k, v) ->
        # if player isn't yet in the roster position, push the position
        # this is helpful because the template iterates over this array, and we can have a placeholder of position
        if v == 'open'
          # add position
          rosterArray.push k
        else
          # else add the player selected
          rosterArray.push v

    return rosterArray

  # Declarative way to find if player is in curent lineup, could use jQuery way
  # of simply switching a class on the player as this is fairly processor intensive.
  inCurrentLineup: ->
    rosterJSON = Session.getJSON 'currentLineup.roster'
    result = false # assume player is not in lineup, until proven true
    $.each rosterJSON, (k, v) =>
      if v._id and v._id._str == @._id._str
        result = true # return true if the player is in the current lineup
        return false # to break out of $.each loop

    return result

  # Returns the Event Name
  # Template calls like this to pass parent data context: {{currentGame ..}}
  # If you want to bold the current Game, you may need to break this up into a different helper
  currentGame: (parentDataContext) ->
    # @ is an Athlete / NflPlayer object (NflPlayer to be deprecated)
    # parentDataContext should be a Contest obj
    # Checks if player 
    for event in parentDataContext.fixture.events
      if @.team_id == event.home || @.team_id == event.away
        return event.away + " vs. " + event.home


Template.contestLineupContainer.events
  'click .position-filter': (e) ->
    filterText = $(e.target).text()
    Session.setJSON 'playerListFilter.position', filterText

  'click .lineup-player-add': (e) ->
    # @ is the data context of the template for the click handler, ie. the player
    addPlayerToRoster(@)

  'click .lineup-player-remove': (e) ->
    rosterJSON = Session.getJSON 'currentLineup.roster'

    $.each rosterJSON, (k, v) =>
      # compare player removed to roster session variable
      # shortcircuit if there is no player object (e.g. v._id)
      if v._id and @._id._str == v._id._str
        rosterJSON[k] = 'open' # reset spot to open

    # save to Session object
    Session.setJSON 'currentLineup.roster', rosterJSON

  'click .lineup-clear-all': (e) ->
    confirmation = confirm('Are you sure you want to clear your lineup?')

    # clear
    if confirmation
      rosterJSON = Session.getJSON 'currentLineup.roster'

      $.each rosterJSON, (k, v) =>
        rosterJSON[k] = 'open'

      Session.setJSON 'currentLineup.roster', rosterJSON

  # The lineup will be in the Session.getJSON 'currentLineup.roster'
  # TODO: Consolidate naming - Roster or Lineup
  'click .contest-entry': (e) ->

    if validateEntry()
      # @ is a Contest object
      entry = {
        userId: Meteor.userId()
        contestId: @._id
        fixtureId: @.fixture.id
        contestStarts: @.startsAt
        contestName: @.contestName
        contestSport: @.sport
        contestType: @.contestType
        entryFee: @.entryFee
        # status: @.status # TODO: Update this value when contest is live
        roster: Session.getJSON 'currentLineup.roster'
      }

      console.log 'we will enter this contest entry', entry

      Meteor.call 'entryCreate', entry, (error, result) ->
        return console.log error.reason if error
        # 'result' is the created entry _id
        Router.go 'entryLayout', { _id: result }
    else
      alert('Please select a player for each position!')



Template.contestLineupContainer.rendered = ->
  # Defaults
  Session.setJSON 'playerListFilter.position', 'QB'
  Session.setJSON "playerListFilter.teams", undefined

  # Color Themes: http://manos.malihu.gr/repository/custom-scrollbar/demo/examples/scrollbar_themes_demo.html
  #
  @$('#player-list-table-container').mCustomScrollbar
    theme: 'minimal-dark'
    autoHideScrollbar: true

  roster = {
    'QB': 'open'
    'RB1': 'open'
    'RB2': 'open'
    'WR1': 'open'
    'WR2': 'open'
    'WR3': 'open'
    'FLEX1': 'open'
    'FLEX2': 'open'
    'TE': 'open'
    'K': 'open'
    # 'DEF': 'open'
  }

  Session.setJSON('currentLineup.roster', roster)

Template.contestFixtureContainer.events
  'click .event-filter': (e) ->
    if e.target.innerHTML == 'All' # this depends on the DOM, a bit fragile
      Session.setJSON "playerListFilter.teams", undefined
    else # @ is a Contest obj
      Session.setJSON "playerListFilter.teams", [@.home, @.away]

# Template.contestFixtureContainer.rendered = ->
#   @$('#event-filters-container').mCustomScrollbar
#     theme: 'minimal-dark'
#     axis: "x"
