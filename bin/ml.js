#!/usr/bin/env node
process.title = 'ml';

var cliopt = require('cliopt');
var generator = require('youmeb-generator');
var colors = require('colors');
var Promise = require('bluebird');
var fs = Promise.promisifyAll(require("fs"));
var isfeatureConfigExist = false;

var cmds = {
  'burn': 'Download code to chip',
  'create': 'Create a new Microlattice.js project'
};

var commands = [];

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

fs.readFileAsync(process.env.PWD + '/featureConfig.json')
.then(function() {
  isfeatureConfigExist = true;
  return init();
})
.catch(function() {
  return init();
});

function init() {
  if (process.argv[2] !== 'create' && !isfeatureConfigExist ) {
    /* first use this project command */
    console.log ("This folder is not a Microlattice.js project. Please input `ml create` to create a project!");
  } else if (process.argv[2] === 'create') {
    /* invoke create command */
    if (isfeatureConfigExist) {
      return console.log("Your Microlattice.js project was existed!");
    } else {
      return require('../lib/commands/create')(parser.args, generator, done)
    }
  } else {
    /* other commands */
    commands = require('../lib/command');
    var featureConfig = require(process.env.PWD + '/featureConfig');
    var pkgPath = process.env.PWD + '/node_modules/ml-' + featureConfig.IC_CONFIG + '-config';
    var pkg = require(pkgPath + '/package');
    var requirePluginCommand = require(pkgPath + '/' + pkg.main);

    for (command in requirePluginCommand) {
      cmds[command] = requirePluginCommand[command].description;
    }

    parser.parse(process.argv.slice(2), function(err) {
      var command = parser.args.shift();
      if (cmds.hasOwnProperty(command)) {
        return commands[command](parser.args, generator, done);
      }
    });
  }
}