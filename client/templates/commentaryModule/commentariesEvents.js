// Written in JS since CS wasn't compiling properly with the preventDefault

Template.commentaryArea.events({ 
	'submit form': function(e) {
    e.preventDefault();

		var commentaryAttr = {
			commentary: $(e.target).find('[id=commentary]').val()
		};
		
		console.log(commentaryAttr)

		Meteor.call('commentaryInsert', commentaryAttr, function (error, result) {
			if(error){
				return alert(error.reason)
			}
		})

  //   Router.go('postPage', post);
  }
});