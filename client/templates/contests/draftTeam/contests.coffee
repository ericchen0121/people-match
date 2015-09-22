# The Contest Page adding Player to lineups/Rosters Functionality
# Currently the implementation stores a NflPlayer object in a Session json variable
# This variable looks like: { QB: [obj], RB1: [obj], WR1: [obj], WR2: 'open'} // 'open' if roster spot is open.
# All are reset to 'open' on hot code pushes.
#
# NOTE: We should persist this roster somehow and/or do checks if a user leaves a contest page
# or submits after a contest is filled up, and wants to remember his lineup.
addPlayerToRoster = (player) ->
  console.log player
  currentRoster = Session.getJSON 'currentLineup.roster'
  toastr.options = {
    "positionClass": "toast-bottom-full-width",
    "preventDuplicates": false,
    "showDuration": "300",
    "hideDuration": "500",
    "timeOut": "1500"
  }
  #   
  # NFL POSITIONS
  #
  switch player.position
    when 'QB'
      if currentRoster['QB'] is 'open' then Session.setJSON 'currentLineup.roster.QB', player else toastr.info 'QBs are Full'
    when 'RB'
      if currentRoster['RB1'] is 'open'
        Session.setJSON 'currentLineup.roster.RB1', player
      else if currentRoster['RB2'] is 'open'
        Session.setJSON 'currentLineup.roster.RB2', player
      else if currentRoster['FLEX1'] is 'open'
        Session.setJSON 'currentLineup.roster.FLEX1', player
      else if currentRoster['FLEX2'] is 'open'
        Session.setJSON 'currentLineup.roster.FLEX2', player
      else toastr.info 'RBs are Full'
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
      else toastr.info 'WRs are Full'
    when 'TE'
      if currentRoster['TE'] is 'open'
        Session.setJSON 'currentLineup.roster.TE', player
      else if currentRoster['FLEX1'] is 'open'
        Session.setJSON 'currentLineup.roster.FLEX1', player
      else if currentRoster['FLEX2'] is 'open'
        Session.setJSON 'currentLineup.roster.FLEX2', player
      else toastr.info 'TEs are Full'
    when 'K'
      if currentRoster['K'] is 'open' then Session.setJSON 'currentLineup.roster.K', player else toastr.info 'Ks are Full'
    when 'DEF'
      if currentRoster['DEF'] is 'open' then Session.setJSON 'currentLineup.roster.DEF', player else toastr.info 'DEFs are Full'
   
  #   
  # NBA POSITIONS
  #
    when 'PG'
      if currentRoster['PG'] is 'open' 
        Session.setJSON 'currentLineup.roster.PG', player
      else if currentRoster['G'] is 'open'
        Session.setJSON 'currentLineup.roster.G', player
      else if currentRoster['UTIL'] is 'open'
        Session.setJSON 'currentLineup.roster.UTIL', player
      else toastr.info 'PGs are Full'
    when 'SG'
      if currentRoster['SG'] is 'open'
        Session.setJSON 'currentLineup.roster.SG', player
      else if currentRoster['G'] is 'open'
        Session.setJSON 'currentLineup.roster.G', player
      else if currentRoster['UTIL'] is 'open'
        Session.setJSON 'currentLineup.roster.UTIL', player
      else toastr.info 'SGs are Full'
    when 'SF'
      if currentRoster['SF'] is 'open'
        Session.setJSON 'currentLineup.roster.SF', player
      else if currentRoster['F'] is 'open'
        Session.setJSON 'currentLineup.roster.F', player
      else if currentRoster['UTIL'] is 'open'
        Session.setJSON 'currentLineup.roster.UTIL', player
      else toastr.info 'SFs are Full'
    when 'PF'
      if currentRoster['PF'] is 'open'
        Session.setJSON 'currentLineup.roster.PF', player
      else if currentRoster['F'] is 'open'
        Session.setJSON 'currentLineup.roster.F', player
      else if currentRoster['UTIL'] is 'open'
        Session.setJSON 'currentLineup.roster.UTIL', player
      else toastr.info 'PFs are Full'
    when 'C'
      if currentRoster['C'] is 'open' 
        Session.setJSON 'currentLineup.roster.C', player
      else if currentRoster['UTIL'] is 'open'
        Session.setJSON 'currentLineup.roster.UTIL', player
      else toastr.info 'Ks are Full'

validateEntry = ->
  rosterJSON = Session.getJSON 'currentLineup.roster'
  valid = true # assume contest entry is true until proven false ;)

  if rosterJSON
    $.each rosterJSON, (k, v) =>
      if v == 'open' || v._id == undefined
        valid = false
        Session.set 'invalidEntryMessage', 'Please select a player for each position!'
        return false # this false breaks out of $.each loop

  if Session.get('remainingSalary') < 0
    valid = false
    Session.set 'invalidEntryMessage', 'You went over the salary cap!'

  console.log valid
  return valid

# Returns a list of all teams in the Contest
# QUESTION: Why does this calculate three times?
availableTeams = (contest) ->
  events = contest.fixture.events # array of Events
  teams = []
  for event in events
    if event.sport == 'NFL' || event.sport == 'NBA'
      teams.push event.home
      teams.push event.away
    # if event.sport == 'CBB'

  return teams

Template.contestLineupContainer.helpers
  
  # Returns the positions to filter for each respective sport.
  # @data-param @ is the Contest object, from the template context
  # @return Array of positional filters in Available Players section
  # 
  positionFilters: ->
    sport = @.sport

    switch sport
      when 'NFL'
        return ['QB', 'RB', 'WR', 'TE', 'K', 'D']
      when 'NBA'
        return ['PG', 'SG', 'SF', 'PF', 'C', 'G', 'F', 'UTIL']

  # Returns the available players in the contest, based on the sport, teams and contest fixtures
  # @data-param @ is the Contest object, from the template context
  # @return Array of positional filters in Available Players section
  # 
  availablePlayers: ->
    # Setup
    sport = @.sport
    position_filter = Session.getJSON 'playerListFilter.position'
    selectedTeamFilter = Session.getJSON 'playerListFilter.teams'

    # Logic
    team_filter = if selectedTeamFilter? then selectedTeamFilter else availableTeams(@)

    # Sports
    switch sport
      # TODO: Change NflPlayers to Athletes
      when 'NFL'
        switch position_filter
          when 'All'
            NflPlayers.find({ team_id: { $in: team_filter }, position: { $in: ['QB', 'RB', 'FB', 'WR', 'TE', 'K', 'DEF'] }, status: 'ACT'})
          when 'K' # edge case when filter won't match position name
            NflPlayers.find({ team_id: { $in: team_filter }, position: 'K', status: 'ACT' })
          when 'D' # another edge case
             NflPlayers.find({ position: 'DEF', status: 'ACT' })
          else
            NflPlayers.find({ position: position_filter, team_id: { $in: team_filter }, status: 'ACT'})

      when 'NBA'
        switch position_filter
          when 'All'
            # TODO: add status: 'ACT' to athletes find
            Athletes.find({ sport: sport, team_id: {$in: team_filter }, position: { $in: ['PG', 'SG', 'SF', 'PF', 'C', 'G', 'F'] }})
          # when 'UTIL'
          #   Athletes.find({ team_id: {$in: team_filter }, position: { $in: ['PG', 'SG', 'SF', 'PF', 'C', 'G', 'F'] }})
          else
            Athletes.find({ sport: sport, position: position_filter, team_id: { $in: team_filter }})

  salaryRemaining: ->
    totalSalary = 80000
    rosterJSON = Session.getJSON 'currentLineup.roster'

    if rosterJSON
      $.each rosterJSON, (k, v) =>
        if v != 'open' # then there is a player
          totalSalary -= v['salary']
    
    Session.set 'remainingSalary', totalSalary

    # toLocalString() adds the commas for 10000 to be 10,000
    return totalSalary.toLocaleString()

  salaryRemainingAvg: ->
    averageSalary = Session.get 'remainingSalary'
    rosterJSON = Session.getJSON 'currentLineup.roster'
    openSpots = 0

    if rosterJSON
      $.each rosterJSON, (k,v) ->
        if v == 'open'
          openSpots += 1

    if openSpots != 0 # no division by zero
      averageSalary /= openSpots

    return Math.floor(averageSalary).toLocaleString()

  # Generates the Lineup View based on Session Data.
  # returns: [Array] of Athlete Objects
  currentLineup: ->

    rosterJSON = Session.getJSON 'currentLineup.roster'

    # convert the JSON form into an array for iterating inside the Template
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
    # 
  inCurrentLineup: ->
    rosterJSON = Session.getJSON 'currentLineup.roster'
    result = false # assume player is not in lineup, until proven true
    if rosterJSON
      $.each rosterJSON, (k, v) =>
        if v._id and v._id._str == @._id._str
          result = true # return true if the player is in the current lineup
          return false # to break out of $.each loop

    return result

  # Returns the event's matchup description, ie. 'NE vs. SEA'
  # 
  # TODO: Feature: If you want to bold the current Game, you may need to break this up into two separate helpers
  # @data-param @: [@] an Athlete / NflPlayer object (to be deprecated)
  # @parentDataContext [obj] a Contest obj, the parent context
  # Usage: [template] Template calls like this to pass parent data context: {{ getCurrentGame .. }}
  # 
  getCurrentEvent: (parentDataContext) ->
    athlete = @
    contest = parentDataContext

    for event in contest.fixture.events
      if athlete.team_id == event.home || athlete.team_id == event.away
        return event.away + " vs. " + event.home


Template.contestLineupContainer.events
  # http://www.kirupa.com/html5/handling_events_for_many_elements.htm
  'click .position-filters': (e) ->
    if e.target != e.currentTarget
      filterText = $(e.target).closest('.position-filter-tab').find('.position-filter').text() #closest and find are friends
      Session.setJSON 'playerListFilter.position', filterText
    e.stopPropagation()

  # @data-param @: [@] an Athlete / NflPlayer object (to be deprecated)
  # ie. @ is the data context of the template for the click handler
  # 
  'click .lineup-player-add': (e) ->
    athlete = @
    addPlayerToRoster(athlete)

  'click .lineup-player-remove': (e) ->
    rosterJSON = Session.getJSON 'currentLineup.roster'

    if rosterJSON
      $.each rosterJSON, (k, v) =>
        # compare player removed to roster session variable
        # shortcircuit if there is no player object (e.g. v._id)
        if v._id and @._id._str == v._id._str
          rosterJSON[k] = 'open' # reset spot to open

    # save to Session object
    Session.setJSON 'currentLineup.roster', rosterJSON

  'click .lineup-clear-all': (e) ->
    confirmation = confirm('Confirm clearing your lineup?')

    # clear
    if confirmation
      rosterJSON = Session.getJSON 'currentLineup.roster'

      if rosterJSON
        $.each rosterJSON, (k, v) =>
          rosterJSON[k] = 'open'

      Session.setJSON 'currentLineup.roster', rosterJSON

  # The lineup will be in the Session.getJSON 'currentLineup.roster'  
  # @data-param @: [@] Contest object
  # TODO: Consolidate naming - Roster or Lineup
  'click .contest-entry': (e) ->
    valid = validateEntry()

    if valid == true
      contest = @

      # Transform data
      rosterJSON = Session.getJSON 'currentLineup.roster'
      rosterIds = []
      roster = []

      # aggregate ids of all roster players
      # standardize roster to an array of player objects
      if rosterJSON
        $.each rosterJSON, (k, v) =>
          if v.api
            rosterIds.push( v.api.SDPlayerId )
          # add slot name
          v['slot'] = k
          roster.push v

      entry = {
        api: {
          SDPlayerIds: rosterIds
        }
        userId: Meteor.userId()
        contestId: contest._id
        fixtureId: contest.fixture.id
        contestStarts: contest.startsAt
        contestName: contest.contestName
        contestSport: contest.sport
        contestType: contest.contestType
        contestSize: contest.entrySize
        entryFee: contest.entryFee
        # status: contest.status # TODO: Update this value when contest is live
        roster: roster
      }

      Meteor.call 'entryCreate', entry, (error, result) ->
        return console.log error.reason if error
        # 'result' is the created entry _id
        Router.go 'entryLayout', { _id: result }
    else
      toastr.info(Session.get 'invalidEntryMessage')

Template.contestLineupContainer.rendered = ->

  # @data-param: @.data is Contest, this is from Iron-Router's data context for the route.
  # 
  contest = @.data
  sport = contest.sport

  switch sport
    when 'NFL'
      # TODO: can add attribute to the Contest and that will be defined in Contest Creation.
      roster = {
        'QB': 'open'
        'RB1': 'open'
        # 'RB2': 'open'
        'WR1': 'open'
        'WR2': 'open'
        # 'WR3': 'open' 
        'FLEX1': 'open'
        # 'FLEX2': 'open' 
        'TE': 'open'
        'K': 'open'
        'DEF': 'open'
      }

      startingPosition = 'QB'

    when 'NBA'
      roster = {
        'PG': 'open'
        'SG': 'open'
        'SF': 'open'
        'PF': 'open'
        'C': 'open'
        'G': 'open'
        'F': 'open'
        'UTIL': 'open'
      }

      startingPosition = 'PG'
  
  # Set Session Variables
  # 
  Session.setJSON('currentLineup.roster', roster)
  Session.setJSON 'playerListFilter.position', startingPosition
  Session.setJSON "playerListFilter.teams", undefined

  # Color Themes: http://manos.malihu.gr/repository/custom-scrollbar/demo/examples/scrollbar_themes_demo.html
  #
  @$('#player-list-table-container').mCustomScrollbar
    theme: 'minimal-dark'
    autoHideScrollbar: true

  # Bootstrap Modal hack
  # https://github.com/makeusabrew/bootbox/issues/232
  $('body').removeClass('modal-open')

Template.contestFixtureContainer.events

  # @data-param: @ is a Contest
  # 
  'click .event-filter': (e) ->
    contest = @
    if e.target.innerHTML == 'All' # this depends on the DOM, a bit fragile
      Session.setJSON "playerListFilter.teams", undefined
    else
      # TODO: logic to add more teams to it, and remove if they're already in there
      Session.setJSON "playerListFilter.teams", [contest.home, contest.away]
