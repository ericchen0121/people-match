Template.commentaryArea.helpers
	
	placeholderText: () ->
		'Super Bowl Sunday. Who are you rooting for and why?'

Template.commentaryArea.rendered = ->
	# Creates a dynamically expanding textarea for commentaries.
	# uses Meteors copleykj:jquery-autosize package 
	# https://atmospherejs.com/copleykj/jquery-autosize
	@$('#commentary').autosize()
