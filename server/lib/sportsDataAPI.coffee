# SETUP Sports Data API Server-side Globals
#
sd_API_KEY = 'u5jw8rhnqtqvr5k8zwgnjm3k'

@sd = Meteor.npmRequire('sportsdata')

# // Init the object with the access level, version, apikey, year, and season you care about
# CAN MOVE THIS INTO A Meteor.method so user can author PRE, PST or REG for NFL
@sd.NFL.init('t', 1, sd_API_KEY, '2014', 'PST')

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
