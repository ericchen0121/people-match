Template.positionDropdown.helpers

  positions: ->
    ['All', 'QB', 'RB', 'WR', 'TE', 'FB',  'C', 'OG', 'OT', 'LB', 'CB', 'SS', 'FS', 'S', 'DT', 'DE', 'PK']


Template.teamDropdown.helpers

  nflTeams: ->
    NflTeams.find()
