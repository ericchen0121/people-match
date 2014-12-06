Template.contestResultsContainer.helpers

  # Presents a human readable moment.js time
  #
  momentify: (time) ->
    moment(time).format('ddd, h:mmA')

  # Powers the contest list view of the lobby
  # Returns an Array of contest objects
  #
  contests: ->
    contestFixture =
      {
      contestId: 'abcd123'
      sport: 'NFL'
      contestType: 'h2h'
      contestName: 'NFL - $300000 Escape Bowl'
      guaranteedPrizes: true
      multipleEntries: true
      multipleEntriesAllowed: 25
      entries: 0
      size: 50
      entryFee: 100
      prizes: 100
      starts: new Date()
      }
    contestSet = (contestFixture for i in [1..250])
    return contestSet

Template.contestResultsContainer.rendered = ->
  # Uses Malihu's scrollbar Meteor package, which as of 12/4/2014 is on v3.0.3
  # v3.0.3 GH: https://github.com/malihu/malihu-custom-scrollbar-plugin/tree/4c5c287a28b5294408c16c5bf5e024e0f0059685
  # Color Themes: http://manos.malihu.gr/repository/custom-scrollbar/demo/examples/scrollbar_themes_demo.html
  # Atmosphere Package: https://atmospherejs.com/maazalik/malihu-jquery-custom-scrollbar
  #
  @$('#contestResultsTable').mCustomScrollbar
    theme: 'minimal-dark'
    autoHideScrollbar: true
    scrollInertia: 300
