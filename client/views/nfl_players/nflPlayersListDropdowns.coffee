Template.positionDropdown.helpers

  positions: ->
    ['All', 'QB', 'RB', 'WR', 'TE', 'FB',  'C', 'OG', 'OT', 'LB', 'CB', 'SS', 'FS', 'S', 'DT', 'DE', 'PK']


Template.teamDropdown.helpers

  nflTeams: ->
    # using Fetch over Find
    # http://stackoverflow.com/questions/16601957/meteor-use-fetch-or-find-in-template-helper-functions
    #
    NflTeams.find().fetch()
