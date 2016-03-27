var child = require('child_process');

module.exports = function(arg, generate, done) {
  var clone = child.exec('git clone https://github.com/iamblue/ml-template-basic.git tmp');
  clone.stderr.on('data', function (data) {
    console.log(data);
  })
  clone.on('exit', function(data) {
    child.exec('cp -R ./tmp/ ./ && rm -rf ./tmp/ && rm -rf .git');
    console.log("Finished!");
  });
}