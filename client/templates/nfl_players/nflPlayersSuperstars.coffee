Template.superstarsFeed.helpers

  superstars: ->
    NflSuperstars.find {}, { sort: { createdAt: -1 } }

Template.superstarFeedCardPhoto.helpers
  superstarPlayer: ->
    # This helper is used inside of the {{#each superstars}} block of nflPlayersSuperstars template.
    # thus @nflPlayerId refers to the attr on the superstar object.
    # sort by latest first
    NflPlayers.findOne @nflPlayerId 

# This helper is duplicated due to a nested helper
# Maybe can use Parent data context
# https://www.discovermeteor.com/blog/a-guide-to-meteor-templates-data-contexts/
Template.superstarFeedCardInfo.helpers
  superstarPlayer: ->
    NflPlayers.findOne @nflPlayerId 

