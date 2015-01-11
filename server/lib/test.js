// console.log('cool')
// Metrics = new Mongo.Collection('metrics');
// Metrics.insert({ sport: 'NFL', contestName: 'eric', entrySize: 35});
// Metrics.insert({ sport: 'NFL', contestName: 'bobby', entrySize: 30});

// var pipeline = [{ $match : { sport : 'NFL'}}, {$project: {contestName: 1, entrySize: 1}}];
// console.log('done');
// // Metrics.aggregate(pipeline);
// var result = Metrics.aggregate({$match: {sport: 'NFL'}});
// // result = Metrics.find()
// console.log(result);