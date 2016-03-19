#!/usr/bin/env node
process.title = 'ml';

var cliopt = require('cliopt');
var commands = require('../lib/command');
var generator = require('youmeb-generator');
var colors = require('colors');

var cmds = {
  'burn': 'download code to chip',
};

try {
  var featureConfig = require(process.env.PWD + '/featureConfig');
  var pkgPath = process.env.PWD + '/node_modules/ml-' + featureConfig.IC_CONFIG + '-config';
  var pkg = require(pkgPath + '/package');
  var requirePluginCommand = require(pkgPath + '/' + pkg.main);

  for (command in requirePluginCommand) {
    cmds[command] = requirePluginCommand[command].description;
  }
} catch(e) {
  console.log(e);
}

var done = function(err){
  if (err) {
    console.log('\n Error: '.red + (err.message || 'no message') + '\n');
  }
};

var parser = cliopt({
  help: {
    type: Boolean,
    default: false,
  }
});

parser.use(cliopt.pair());
parser.use(cliopt.convert());
parser.parse(process.argv.slice(2), function(err) {
  var command = parser.args.shift();
  if (cmds.hasOwnProperty(command)) {
    return commands[command](parser.args, generator, done);
  }
});
