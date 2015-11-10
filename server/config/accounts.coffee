#--------------------------------PRODUCTION / DEVELOPMENT VARIABLES----------------------------------------
console.log '---------------PRODUCTION / DEVELOPMENT VARIABLES----------', process.env.NODE_ENV

@inDevelopment = ->
  return process.env.NODE_ENV == "development"

@inProduction =->
  return process.env.NODE_ENV == "production"

# --------------------- ENRICH DATA OF PROFILES ---------------------
# Adds Profile Picture link to users
# http://stackoverflow.com/questions/15018552/how-to-query-a-facebook-user-picture-via-meteors-accounts-facebook
#
Accounts.onCreateUser( (options, user) ->
  if options.profile
    if typeof(user.services.facebook) != "undefined" 
      # FB allows for other image sizes, the param is ?type= square |small| normal | large
      options.profile.picture = "http://graph.facebook.com/" + user.services.facebook.id + "/picture/?type=square"
    else if typeof(user.services.twitter) != 'undefined'
      options.profile.picture = user.services.twitter.profile_image_url

    user.profile = options.profile
  return user
)

# --------------------- ROLES --------------------- 
# uses `alanning:roles` package
ericAdminUserId = Meteor.settings.admin.eric
ericAdminUserIdProduction = Meteor.settings.admin.ericProduction

if @inDevelopment == true
	Roles.addUsersToRoles(ericAdminUserId, ['admin'])
if @inProduction == true
	Roles.addUsersToRoles(ericAdminUserIdProduction, ['admin'])