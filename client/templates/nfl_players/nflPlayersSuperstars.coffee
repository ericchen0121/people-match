Template.nflPlayersSuperstars.helpers

  superstars: ->
    NflSuperstars.find( {}, { sort: { createdAt: -1 } })

Template.nflPlayersSuperstarCard.helpers
  superstarPlayer: ->
    # This helper is used inside of the {{#each superstars}} block of nflPlayersSuperstars template.
    # thus @nflPlayerId refers to the attr on the superstar object.
    # sort by latest first
    NflPlayers.findOne( @nflPlayerId )

