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
      else alert 'RBs are Full'
    when 'WR'
      if currentRoster['WR1'] is 'open'
        Session.setJSON 'currentLineup.roster.WR1', player
      else if currentRoster['WR2'] is 'open'
        Session.setJSON 'currentLineup.roster.WR2', player
      else if currentRoster['WR3'] is 'open'
        Session.setJSON 'currentLineup.roster.WR3', player
      else alert 'WRs are Full'
    when 'TE'
      if currentRoster['TE'] is 'open' then Session.setJSON 'currentLineup.roster.TE', player else alert 'TEs are Full'
    when 'K'
      if currentRoster['K'] is 'open' then Session.setJSON 'currentLineup.roster.K', player else alert 'Ks are Full'
    when 'DEF'
      if currentRoster['DEF'] is 'open' then Session.setJSON 'currentLineup.roster.DEF', player else alert 'DEFs are Full'

  console.log Session.getJSON("currentLineup.roster")

Template.contestLineupContainer.helpers

  availablePlayers: ->
    NflPlayers.find({})

  salaryRemaining: ->
    60000

  salaryRemainingAvg: ->
    60000 / 12

  # Generates the Lineup View based on Session Data.
  # returns: [Array] of Athlete Objects
  currentLineup: ->
    rosterJSON = Session.getJSON 'currentLineup.roster'

    # convert the JSON form into an array for template iteration
    rosterArray = []
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

Template.contestLineupContainer.events
  'click .player-add': (e) ->
    # @ is the data context of the template, ie. the player
    addPlayerToRoster(@)

  'click .lineup-player-remove': (e) ->
    rosterJSON = Session.getJSON 'currentLineup.roster'

    $.each rosterJSON, (k, v) =>
      # compare player removed to roster session variable
      # shortcircuit if there is no player object (v._id)
      if v._id and @._id._str == v._id._str
        # reset spot to open
        rosterJSON[k] = 'open'

    # save
    Session.setJSON 'currentLineup.roster', rosterJSON

Template.contestLineupContainer.rendered = ->
  # Color Themes: http://manos.malihu.gr/repository/custom-scrollbar/demo/examples/scrollbar_themes_demo.html
  #
  @$('#player-list-table').mCustomScrollbar
    theme: 'minimal-dark'
    autoHideScrollbar: true

  lineupPositions = {
    'QB': 1
    'RB': 1
    'WR': 3
    'TE': 1
    'K': 1
    'DEF': 1
  }

  Session.setJSON('currentLineup.positions', lineupPositions)

  # this uses the Contests.lineupPositions
  # Session.setJSON('currentLineup.positions', @.lineupPositions)

  roster = {
    'QB': 'open'
    'RB1': 'open'
    'RB2': 'open'
    'WR1': 'open'
    'WR2': 'open'
    'WR3': 'open'
    'TE': 'open'
    'K': 'open'
    'DEF': 'open'
  }

  Session.setJSON('currentLineup.roster', roster)
