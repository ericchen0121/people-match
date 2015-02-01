-------------- RESTORING A METEOR DEPLOYED APP FROM A LOCAL MONGO DB ---------------
// 1. dump a local collection 
//
mongodump -h 127.0.0.1 --port 3001 -d meteor

// 2. get deployed meteor app's credentials
//
meteor mongo --url $METEOR_APP_URL

meteor mongo --url infinityprimal.meteor.com

// parse that response into this form, 
// replacing the username, password, db (if different) and hostname (probably slightly different)
// run this command in the meteor project folder that has the dump/meteor folder in it
//
mongorestore -u client-bc79eed6  -p 9113b9a8-f884-2e1c-28ac-4dbb225f50fb --db infinityprimal_meteor_com -h production-db-d3.meteor.io:27017 dump/meteor

// add this flag if just dumping and restoring a collection
//
-c comments.bson

-------------- LOGIN TO A METEOR DEPLOYED APP ---------------
// http://stackoverflow.com/questions/15583107/meteor-app-resetting-a-deployed-apps-db
//
mongo production-db-d3.meteor.io:27017/infinityprimal_meteor_com -u client-2d27c3bf -p 0216f56a-1500-1beb-264b-455b3d536cd0


-------------- EXPORT/IMPORT LOCAL METOR MONGO COLLECTION TO CSV ---------------
// http://docs.mongodb.org/manual/core/import-export/
//
mongoexport -h 127.0.0.1 --port 3001 -d meteor -c nflPlayers --csv -f "full_name,salary,position,team_id" --out athletes.csv

mongoimport --collection collection --file collection.json --upsert
mongoimport -h 127.0.0.1 --port 3001 -d meteor -c nflPlayers --file athletes.csv --upsert

// these didn't work for me.
//
mongoimport -h 127.0.0.1 --port 3001 -d meteor -c nflPlayers --upsert --file athletes.csv --upsertFields "espn_id"  --type csv --ignoreBlanks --headerline

mongoimport -h 127.0.0.1 --port 3001 -d meteor -c nflPlayers --upsert --file athletes.csv  --type csv --headerline