# http://www.neo.com/2014/05/23/reactive-forms-in-meteor-js
window.Events = {}

Events.handleNaturally = (e) ->
  e.preventDefault()
  e.stopPropagation()

# This file defines global helpers which can be used across templates.
# https://docs.meteor.com/#/full/template_registerhelper

# Provides an easy ESPN src image given a data context
# Required: `espn_id` and `espn_size` attributes
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
    return "images/withOutPhoto.png"

# Presents a human readable moment.js time
#
Template.registerHelper 'momentify', (time, formatName) ->
    # mediumDateTime: e.g. Sun, 1:00PM
    #
    if formatName == 'mediumDateTime'
      moment(time).format('ddd, h:mmA')
    # shortTime: e.g. 1:00PM
    #
    else if formatName == 'shortTime'
      moment(time).format('h:mmA')
    else  # default to MediumDateTime
      moment(time).format('ddd, h:mmA')
