var path = require('path');
var fs = require('fs');

commands = module.exports = {};

commands['burn'] = require('./commands/burn');

var featureConfig = require(process.env.PWD + '/featureConfig');
var pkgPath = process.env.PWD + '/node_modules/ml-' + featureConfig.IC_CONFIG + '-config';
var pkg = require(pkgPath + '/package');
var requirePluginCommand = require(pkgPath + '/' + pkg.main);

for (command in requirePluginCommand) {
  commands[command] = requirePluginCommand[command].source;
}

