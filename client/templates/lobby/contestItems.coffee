Template.contestItems.events

  # Twitter Bootstrap Modal JS Events
  #
  'show.bs.modal .contestModal': (e) ->
    # If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    # Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.

    # Get Data-* Properties
    triggerEl = $(e.relatedTarget) # Element that triggered the modal
    contestName = triggerEl.data('name') # Extract info from data-* attributes, in this case data-name

    # data = $(this).data
    # console.log 'this is the data', data

    # Set Modal content
    modal = $(e.target)
    modal.find('.modal-title').text(contestName + ' Tournament!')

  # QUESTION: Why doesn't this event handler belong in the
  # inner 'contestModal' template?
  # Initializes Bootstrap JS Tabs
  # http://getbootstrap.com/javascript/#tabs
  #
  'click ul.nav.nav-tabs > li > a': (e) ->
    e.preventDefault()
    $(e.target).tab('show')

Template.contestModal.helpers

  # TODO: CHANGE this to be pulling from the contest
  readablePrizePayouts: ->
    '1st: $500'

Template.contestModal.events
  # hack solution for .modal-open not disappering on modal close
  # https://github.com/makeusabrew/bootbox/issues/232
  # 
  # 'hide.bs.modal .contestModal': (e) ->
  #   $('.modal-open').removeClass('modal-open')

Template.contestItems.helpers

  # When the contests are in the DB, flip this switch to turn it on!
  contestsFuture: ->
    Contests.find({startsAt: mq.future}, { sort: { startsAt: 1 }} ) # TODO: filter these down to contests in the next few days

  contestsPast: ->
    Contests.find({startsAt: mq.past}, { sort: { startsAt: 1 }} )

Template.contestItems.rendered = ->
  # Uses Malihu's scrollbar Meteor package, which as of 12/4/2014 is on v3.0.3
  # v3.0.3 GH: https://github.com/malihu/malihu-custom-scrollbar-plugin/tree/4c5c287a28b5294408c16c5bf5e024e0f0059685
  # Color Themes: http://manos.malihu.gr/repository/custom-scrollbar/demo/examples/scrollbar_themes_demo.html
  # Atmosphere Package: https://atmospherejs.com/maazalik/malihu-jquery-custom-scrollbar
  #
  @$('#contestResultsTable').mCustomScrollbar
    theme: 'minimal-dark'
    autoHideScrollbar: true
    scrollInertia: 300

  # This resets the contest entry to be empty upon loading the view page, fixing the problem
  # of an old entry being shown then removed
  # NOTE: There could be a problem where the entry may show NFL positions if its an NBA team then 
  # switch. If so, you be smarter in the logi (can you set it upon hitting the route? or figure out which 
    # sport the user is looking at)
  #
  roster = {
    'QB': 'open'
    'RB1': 'open'
    'RB2': 'open'
    'WR1': 'open'
    'WR2': 'open'
    # 'WR3': 'open' 
    'FLEX1': 'open'
    # 'FLEX2': 'open' 
    'TE': 'open'
    'K': 'open'
    'DEF': 'open'
  }
  
  # Set Session Variables
  # 
  Session.setJSON('currentLineup.roster', roster)