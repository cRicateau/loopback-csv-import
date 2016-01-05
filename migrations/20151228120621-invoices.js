var dbm = global.dbm || require('db-migrate');
var type = dbm.dataType;
var fs = require('fs');
var path = require('path');

exports.up = function(db, callback) {
  var filePath = path.join(__dirname + '/sqls/1-invoices.up.sql');
  fs.readFile(filePath, {encoding: 'utf-8'}, function(err,data){
    if (err) return callback(err);
    console.log('received data: ' + data);

    db.runSql(data, function(err) {
      if (err) return callback(err);
      callback();
    });
  });
};

exports.down = function(db, callback) {
  var filePath = path.join(__dirname + '/sqls/1-invoices.down.sql');
  fs.readFile(filePath, {encoding: 'utf-8'}, function(err,data){
    if (err) return callback(err);
    console.log('received data: ' + data);

    db.runSql(data, function(err) {
      if (err) return callback(err);
        callback();
      });
    });
};
