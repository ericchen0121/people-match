# SETUP Sports Data API Server-side Globals
#
sd_API_KEY = 'u5jw8rhnqtqvr5k8zwgnjm3k'

@sd = Meteor.npmRequire('sportsdata')
@sd.NFL = @sd.NFL
@sd.NFL.init('t', 1, sd_API_KEY, '2014', 'REG')

# ASYNC UTILITIES WRAPPING 'node-sportsdata' API
# METEORHACKS:NPM
#
@sd.NFL.nflGetWeeklySchedule = Async.wrap(sd.NFL.getWeeklySchedule)
