# This file defines global helpers which can be used across templates.
# https://docs.meteor.com/#/full/template_registerhelper

# ---------------------------------------- Mongo Query Helpers ----------------------------------------

today = moment().startOf('day').toISOString()
yesterday = moment(today).subtract(1, 'days').toISOString()
tomorrow = moment(today).add(1, 'days').toISOString()
lastThreeDays = moment(today).subtract(3, 'days').toISOString()
lastWeek = moment(today).subtract(7, 'days').toISOString()

window.mq = {}
mq.future = { $gte: new Date().toISOString() }
mq.past = { $lte: new Date().toISOString() }
mq.today = { $gte: today, $lt: tomorrow }
mq.yesterday = { $gte: yesterday, $lt: today }
mq.lastFewDays = { $gte: lastThreeDays, $lt: tomorrow }
mq.lastWeek = { $gte: lastWeek, $lt: tomorrow }

# ---------------------------------------- Player Images URLS ----------------------------------------
# Required: pass in `espn_id` and `espn_size` attributes in the obj
# Usage like so in a template: <img class='playerPhoto' src={{ playerImageESPN espn_id = this.espn_id espn_size = 'micro'}}>

Template.registerHelper 'playerImageESPN', (obj) ->
  sport = obj.hash.sport || 'NFL'
  espn_id = obj.hash.espn_id

  if obj.hash.espn_size
    size = switch obj.hash.espn_size
      when 'small' then '&w=137&h=100'
      when 'medium' then '&w=274&h=200'
      when 'large' then '&w=350&h=255'
      when 'original' then ''
      when 'micro' then '&w=68&h=50'
      else ''
  else size = ''
  
  return 'http://a.espncdn.com/combiner/i?img=/i/headshots/' + sport.toLowerCase() + '/players/full/' + espn_id + '.png' + size

Template.registerHelper 'teamLogoESPN', (obj) ->
  sport = obj.hash.sport || 'NFL'
  espn_id = obj.hash.espn_id

  if obj.hash.espn_size
    size = switch obj.hash.espn_size
      when 'small' then '&w=100&h=100'
      when 'medium' then '&w=200&h=200'
      else ''
  else size = ''

  return 'http://a.espncdn.com/combiner/i?img=/i/teamlogos/nfl/500/' + espn_id.toLowerCase() + '.png' + size

# ---------------------------------------- Profile Image and Default----------------------------------------
# http://stackoverflow.com/questions/15018552/how-to-query-a-facebook-user-picture-via-meteors-accounts-facebook
Template.registerHelper "userImage", (userId) ->
  user = Meteor.users.findOne({ _id: userId })
  if user.profile.picture
    return user.profile.picture
  else
    # TO CHANGE or Add default photo url
    return "images/icon.jpg"

# ---------------------------------------- Human Readable Time ----------------------------------------
# using Momentify package
# 
Template.registerHelper 'momentify', (time, formatName) ->
    formatted = moment(time)
    # mediumDateTime: e.g. Sun, 1:00PM
    # naming via: http://msdn.microsoft.com/en-us/library/362btx8f%28v=vs.90%29.aspx
    #
    if formatName == 'mediumDateTime'
      formatted.format('ddd, h:mmA')
    # shortTime: e.g. 1:00PM
    #
    else if formatName == 'shortTime'
      formatted.format('h:mmA')

    else if formatName == 'longDateTime'
      formatted.tz('America/New_York').format('ddd, MMM Do h:mmA z')

    # default to MediumDateTime
    else  
      formatted.format('ddd, h:mmA')

# ---------------------------------------- Text Truncating Helper ----------------------------------------
# Truncates the text to the first or last xxx characters
# 
Template.registerHelper 'truncate', (text, position = 'last', numChar) ->
  if position is 'first'
    text.substr(0, numChar)
  else if position is 'last'
    text.substr(text.length - numChar)

# ---------------------------------------- Commas in Numbers ----------------------------------------
# Adds commas!
#
Template.registerHelper 'addCommas', (number) ->
  number.toLocaleString()

# ---------------------------------------- Handle Events ----------------------------------------
# http://www.neo.com/2014/05/23/reactive-forms-in-meteor-js
window.AllEvents = {}

AllEvents.handleNaturally = (e) ->
  e.preventDefault()
  e.stopPropagation()

