Template.playerCardPhoto.helpers

  # obj is passed in as an argument in the template helper.
  # The two attributes of this object are
  # `espn_id`: the id of the player's url page on espn.com
  # `espn_size` String: the size to fetch from espn's cdn
  #
  playerImageESPN: (obj) ->

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

Template.playerSuperstarMe.events

  'click .superstar': (e) ->
    superstar = {
      nflPlayerId: @._id
    }

    console.log "You're a Superstar."

    # Call the server-side method to insert into Db
    # This also adds some properties before addition
    # 
    Meteor.call 'superstarInsert', superstar, (error, result) ->
      return alert(error.reason) if error
