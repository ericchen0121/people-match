Template.commentaryArea.helpers
	
	placeholderText: () ->
		'Commentary, opine, rant, jeer, cheer...'

Template.commentaryArea.rendered = ->
	# Creates a dynamically expanding textarea for commentaries.
	# uses Meteors copleykj:jquery-autosize package 
	# https://atmospherejs.com/copleykj/jquery-autosize
	@$('#commentary').autosize()
