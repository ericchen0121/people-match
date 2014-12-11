Template.contestLineupContainer.helpers

  availablePlayers: ->
    NflPlayers.find({})

  salaryRemaining: ->
    60000

  salaryRemainingAvg: ->
    60000 / 12

Template.contestLineupContainer.rendered = ->
  # Uses Malihu's scrollbar Meteor package, which as of 12/4/2014 is on v3.0.3
  # v3.0.3 GH: https://github.com/malihu/malihu-custom-scrollbar-plugin/tree/4c5c287a28b5294408c16c5bf5e024e0f0059685
  # Color Themes: http://manos.malihu.gr/repository/custom-scrollbar/demo/examples/scrollbar_themes_demo.html
  # Atmosphere Package: https://atmospherejs.com/maazalik/malihu-jquery-custom-scrollbar
  #
  @$('#player-list-table').mCustomScrollbar
    theme: 'minimal-dark'
    autoHideScrollbar: true
    scrollInertia: 300
