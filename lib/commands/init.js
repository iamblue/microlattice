var Promise = require('bluebird');
var fs = require('fs-extra');
var readFile = Promise.promisify(require("fs").readFile);
var mkdir = Promise.promisify(require("fs").mkdir);
var rimraf = require('rimraf');
var path = require('path');
var readInstalled = require("read-installed");
var options = { dev: false, depth: 1 };
var UglifyJS = require("uglify-js");
var Promise = require('bluebird');
var browserify = require('browserify');
var SDK_link = '';

module.exports = function(arg, generate, done) {

  var iotConfig;
  var iotConfigPath = process.env.PWD + '/iotConfig.json';
  var dotCFilePool = [];

  var mlModules = [];

  return new Promise(function (resolve, reject) {
    var package = require(process.env.PWD + '/package.json');
    SDK_link = package.SDKpath;
    resolve();
  })
  .then(function() {
    return new Promise(function (resolve, reject) {
      return rimraf(process.env.PWD + '/tmp', function(error) {
        if(error) { reject(error); }
        return resolve();
      });
    });
  })
  .then(function(){
    return mkdir(process.env.PWD + '/tmp');
  })
  .then(function() {
    return readFile(iotConfigPath, 'utf8');
  })
  .then(function() {

    // process feature.mk content

    var content = '';
    iotConfig = require(iotConfigPath);
    for (props in iotConfig){
      var _content = props;
      if(iotConfig[props]) {
        if (typeof iotConfig[props] === 'string') {
          _content += ' = ' + iotConfig[props];
        } else {
          //  把 ml modules 抽出
          if (/ml\-/.test(_content)) {
            mlModules.push(_content);
          }
          _content += ' = y';
        }
      } else {
        _content += ' = n';
      }
      _content += '\n';
      content += _content;
    }
    return content;
  })
  .then(function(content){

    // generate feature.mk

    generate
    .create(path.join(__dirname, '../templates'), path.join(process.cwd(), './'))
    .createFile('./feature.mk', './tmp/feature.mk', { content: content }, done);
    console.log("Generate feature.mk success!");
  })
  .then(function() {

    return new Promise(function (resolve, reject) {
      return readInstalled(process.cwd(), options, function (err, data) {
        if (err) reject(err);
        resolve(data);
      });
    });
  })
  .then(function(data) {

    var content = '';

    for (package in data.dependencies) {
      if (data.dependencies[package].src && /^ml\-/.test(package) && package !== 'ml-cli') {
        for (var index in data.dependencies[package].src) {
          if (/\.c$/.test(data.dependencies[package].src[index])) {
            // parse .c file
            var realPath = data.dependencies[package].src[index].replace('.', '');
            dotCFilePool.push(realPath);
            // copy ./src to SDK
            fs.copy(data.dependencies[package].realPath + '/src', SDK_link + '/project/mt7687_hdk/apps/iot_sdk/src/ml/src');
            content += 'APP_FILES += $(APP_PATH_SRC)/ml' + realPath + '\n';

          } else {
            // parse .h file
          }
        }
      }
    }
    return content
  })
  .then(function(content) {

    // generate Makefile

    generate
    .create(path.join(__dirname, '../templates'), path.join(process.cwd(), './'))
    .createFile('./Makefile', './tmp/Makefile', { APP_FILES: content }, done);

    console.log("Generate Makefile success!");
  })
  .then(function(){
    var browserify = require('browserify');
    var b = browserify();
    b.add(process.env.PWD + '/index.js');
    return new Promise(function (resolve, reject) {
      b.bundle(function(err, buffer) {
        if (err) {
          reject(err);
        }
        resolve(buffer.toString());
      });
    });
  })
  .then(function(code){
    var result = UglifyJS.minify(code, {fromString: true});
    // console.log(result.code);

    var c = "global = {};" + result.code;
    var obj = {}; obj.c = c;
    var codeStr = '';
    codeStr += JSON.stringify(obj).replace(/^\{\"c\"\:/, '').replace(/\}$/, '');
    return codeStr;
  })
  .then(function(code) {
    var content = '*/ \n';

    for (var index in mlModules) {
      content += mlModules[index].replace('-', '_' ) + '_init();\n';
    }

    content += '/* ';
    generate
    .create(path.join(__dirname, '../templates'), path.join(process.cwd(), './'))
    .createFile('./main.c', './tmp/main.c', { ML_INIT: content, JS_CODE: code }, done);

    console.log("Generate main.c success!");
  })
  .catch(function(err) {
    return done({ message: err });
  });
}