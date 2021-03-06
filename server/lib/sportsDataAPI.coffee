# SETUP Sports Data API
# 'node-sportsdata' npm, or 'sportsdata-mongo'
# Server-side Globals
#
SD_API_KEY_NFL = Meteor.settings.sdapi.nfl
SD_API_KEY_NBA = Meteor.settings.sdapi.nba
@sd = Meteor.npmRequire('sportsdata-mongo')

# ------------------------- NFL ------------------------- 
# // Init the Sports Data object with the access level, version, apikey, year, and season you care about
# CAN MOVE THIS INTO A Meteor.method so user can author PRE, PST or REG for NFL
@sd.NFL.init('t', 1, SD_API_KEY_NFL, '2015', 'REG', 'json')

# ASYNC UTILITIES WRAPPING 'node-sportsdata' API
# METEORHACKS:NPM
#
@sd.NFLApi = Async.wrap(@sd.NFL, [
  'getWeeklySchedule'
  'getSeasonSchedule'
  'getGameStats'
  'getGameSummary'
  'getPlayByPlay'
  'getPlaySummary'
  'getGameBoxscore'
  'getExtendedBoxscore'
  'getWeeklyBoxscore'
  'getGameRoster'
  'getTeamHierarchy'
  'getTeamRoster'
  'getInjuries'
  'getGameDepthChart'
  'getTeamDepthChart'
  'getWeeklyLeagueLeaders'
  'getStandings'
  'getSeasonalStats'
])


# ------------------------- NBA -------------------------
# @sd.NBA.init('t', 3, SD_API_KEY_NBA, '2014', 'REG', 'json')
# @sd.NBAApi = Async.wrap(@sd.NBA, [
#   'getSeasonSchedule'
#   'getDailySchedule'
#   'getSeriesSchedules'
#   'getBoxScore'
#   'getGameSummary'
#   'getStandings'
#   'getRankings'
#   'getLeagueHierarchy'
#   'getInjuries'
#   'getTeamProfile'
#   'getPlayerProfile'
#   'getPlayByPlay'
#   'getSeasonalStatistics'
#   'getDailyChangeLog'
#   'getDailyTransfers'
# ])

# ------------------------- MLB -------------------------
# @sd.MLB.init('t', 4, sd_API_KEY, '2015', 'REG')