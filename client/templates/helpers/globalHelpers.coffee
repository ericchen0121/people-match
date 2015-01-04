# This file defines global helpers which can be used across templates.
# https://docs.meteor.com/#/full/template_registerhelper

# Events
# http://www.neo.com/2014/05/23/reactive-forms-in-meteor-js
window.AllEvents = {}

AllEvents.handleNaturally = (e) ->
  e.preventDefault()
  e.stopPropagation()

# Mongo Queries
# Mongo Query Helpers (MQH)
window.MQH = {}
MQH.startsInFuture = { startsAt: {$gte: Date.now() }}
MQH.startsInFutureSortAsc = { sort: { startsAt: 1 }}
MQH.contestStartsInFuture = { contestStarts: {$gte: Date.now() }} # TODO: consider consolidating the attribute to startsAt


# Provides an easy ESPN src image given a data context
# Required: pass in `espn_id` and `espn_size` attributes in the obj
# Usage like so in a template: <img class='playerPhoto' src={{ playerImageESPN espn_id = this.espn_id espn_size = 'micro'}}>

Template.registerHelper 'playerImageESPN', (obj) ->

  if obj.hash.espn_size
    size = switch obj.hash.espn_size
      when 'small' then '&w=137&h=100'
      when 'medium' then '&w=274&h=200'
      when 'large' then '&w=350&h=255'
      when 'original' then ''
      when 'micro' then '&w=68&h=50'
      else ''
  else size = ''

  'http://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/' + obj.hash.espn_id + '.png' + size

# http://stackoverflow.com/questions/15018552/how-to-query-a-facebook-user-picture-via-meteors-accounts-facebook
Template.registerHelper "userImage", (userId) ->
  user = Meteor.users.findOne({ _id: userId })
  if user.profile.picture
    return user.profile.picture
  else
    # TO CHANGE or Add default photo url
    return "images/icon.jpg"

# Presents a human readable moment.js time
#
Template.registerHelper 'momentify', (time, formatName) ->
    formatted = moment(time)
    # mediumDateTime: e.g. Sun, 1:00PM
    # naming of: http://msdn.microsoft.com/en-us/library/362btx8f%28v=vs.90%29.aspx
    #
    if formatName == 'mediumDateTime'
      formatted.format('ddd, h:mmA')
    # shortTime: e.g. 1:00PM
    #
    else if formatName == 'shortTime'
      formatted.format('h:mmA')

    else if formatName == 'longDateTime'
      formatted.tz('America/New_York').format('ddd, MMM Do h:mmA z ')

    else  # default to MediumDateTime
      formatted.format('ddd, h:mmA')
