var child = require('child_process');
var Promise = require('bluebird');
var drivelist = require('drivelist');

module.exports = function(arg, generate, done) {

  return new Promise(function (resolve, reject) {
    return drivelist.list(function(error, disks) {
      if (error) { reject(error) };
      for (var index in disks) {
        if (disks[index].description === 'MBED microcontroller Media') {
          return resolve(disks[index].mountpoint);
        }
        if (index === disks.length-1) {
          return reject('Cannot find Mbed device!');
        }
      }
    });
  }).then(function(path) {
    return new Promise(function (resolve, reject) {
      var burn = child.exec('cp ' + arg[0] + ' ' + path);

      burn.stdout.on('data', function (data) {
        console.log(data.toString());
      });
      burn.on('exit', function (data) {
        console.log('==============================================================');
        console.log('Success!'.green + ' Download! ');
        console.log('==============================================================');
        return resolve(data.toString());
      });
      burn.stderr.on('data', function (data) {
        console.log(data.toString());
        if (data) {
          return reject(data.toString());
        }
      });
    });
  })
  .catch(function(err) {
    return done({ message: err });
  });

}