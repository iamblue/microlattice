module.exports = function(arg, generate, done) {
  var featureConfig = require(process.env.PWD + '/featureConfig');
  var protocol = featureConfig.download_protocol || 'mbed'

  switch (featureConfig.download_protocol) {
    case 'mbed':
      require('./burn/mbed')(arg, generate, done);
      break;
    default:
      var pkgPath = process.env.PWD + '/node_modules/ml-' + featureConfig.IC_CONFIG + '-config';
      var pkg = require(pkgPath + '/package');
      var requirePluginCommand = require(pkgPath + '/' + pkg.main);
      requirePluginCommand['burn_' + protocol].source(arg, generate, done);
      break;
  }
}