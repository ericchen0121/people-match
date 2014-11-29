Template.commentaryList.helpers

	commentaries: ->
		Commentaries.find {}, { sort: { createdAt: -1 } }