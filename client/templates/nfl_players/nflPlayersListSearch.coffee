Template.nflPlayerSearchResults.helpers

  # potentially should be global helper function
  searchResultsExist: ->
    searchInstance = EasySearch.getComponentInstance {index: 'nflPlayersSearch'}

    return searchInstance.get('total') != 0
