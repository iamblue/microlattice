var Promise = require('bluebird');
var child = require('child_process');
var readFile = Promise.promisify(require("fs").readFile);
var path = require('path');

module.exports = function(arg, generate, done) {

  return new Promise(function (resolve, reject) {
    if (process.platform === 'darwin') {
      var gccUrl = 'https://launchpad.net/gcc-arm-embedded/4.8/4.8-2014-q3-update/+download/gcc-arm-none-eabi-4_8-2014q3-20140805-mac.tar.bz2';
      var download = child.exec('wget ' + gccUrl + ' -O ./sdk/gcc-arm-none-eabi.tar.bz2');
    } else if (process.platform === 'linux') {
      var gccUrl = 'https://launchpad.net/gcc-arm-embedded/4.8/4.8-2014-q3-update/+download/gcc-arm-none-eabi-4_8-2014q3-20140805-linux.tar.bz2';
      var download = child.exec('wget ' + gccUrl + ' -O ./sdk/gcc-arm-none-eabi.tar.bz2');
    } else if (process.platform === 'win32') {
      var gccUrl = 'https://launchpad.net/gcc-arm-embedded/4.8/4.8-2014-q3-update/+download/gcc-arm-none-eabi-4_8-2014q3-20140805-win32.zip';
      var download = child.exec('wget ' + gccUrl + ' -O ./sdk/gcc-arm-none-eabi.zip');
    }
    download.stderr.on('data', function(data) {
      console.log(data);
    });
    download.on('exit', function() {
      resolve();
    });
  }).then(function() {
    return readFile(process.env.PWD + '/sdk/gcc-arm-none-eabi.tar.bz2');
  })
  .then(function() {
    return new Promise(function (resolve, reject) {
      var unzip = child.exec('mkdir gcc-arm-none-eabi && tar -xvf ./gcc-arm-none-eabi.tar.bz2', { cwd: process.env.PWD + '/sdk' });

      if (process.platform === 'win32') {
        unzip = child.exec('mkdir gcc-arm-none-eabi && unzip ./gcc-arm-none-eabi.zip', { cwd: process.env.PWD + '/sdk' });
      }

      unzip.stdout.on('data', function(data) {
        console.log(data);
      });
      unzip.stderr.on('data', function(data) {
        console.log(data);
      });
      unzip.on('exit', function() {
        return resolve();
      });

    });
  })
  .then(function() {
    return new Promise(function (resolve, reject) {
      var copy = child.exec('cp -r ./gcc-arm-none-eabi-4_8-2014q3/  ./LinkIt_SDK_V3.0.0/tools/gcc/gcc-arm-none-eabi', { cwd: process.env.PWD + '/sdk' });
      copy.stdout.on('data', function(data) {
        console.log(data);
      });
      copy.stderr.on('data', function(data) {
        console.log(data);
      });
      copy.on('exit', function() {
        return resolve();
      });
    });
  })
  .then(function() {
    child.exec('rm -rf ./gcc-arm-none-eabi.tar.bz2 && rm -rf ./gcc-arm-none-eabi-4_8-2014q3/ && rm -rf ./gcc-arm-none-eabi/', { cwd: process.env.PWD + '/sdk' });
    return true;
  })
  .then(function() {
    generate
    .create(path.join(__dirname, '../templates'), path.join(process.cwd(), './'))
    .createFile('./chip.mk', '/Users/blue-mtk/LinkIt_SDK_V3.0.0/config/chip/mt7687/chip.mk', {}, done);

    console.log('==============================================================');
    console.log('Success!'.green + ' Install gcc completely. ');
    console.log('==============================================================');
  })
  .catch(function(err) {
    return done({ message: err });
  });
}