Template.contestResultsContainer.helpers

  momentify: (time) ->
    moment(time).format('ddd h:mmA')

  contests: ->
    contestFixture =
      {
      sport: 'NFL',
      contestName: 'NFL - $300,000 Escape Bowl',
      contestType: 'h2h'
      entries: 0,
      size: 50,
      entryFee: 100,
      prizes: 100,
      starts: new Date()
      }
    contestSet = (contestFixture for i in [1..1500])
    return contestSet

Template.contestResultsContainer.rendered = ->
  # Uses Malihu's scrollbar, Meteor package, which as of 12/4/2014 is on v3.0.3
  # v3.0.3 GH: https://github.com/malihu/malihu-custom-scrollbar-plugin/tree/4c5c287a28b5294408c16c5bf5e024e0f0059685
  # Color Themes: http://manos.malihu.gr/repository/custom-scrollbar/demo/examples/scrollbar_themes_demo.html
  # Atmosphere Package: https://atmospherejs.com/maazalik/malihu-jquery-custom-scrollbar
  @$('#contestResultsTable').mCustomScrollbar
    theme: 'minimal-dark'
    autoHideScrollbar: true
    setTop: '-25px'
    scrollInertia: 300
