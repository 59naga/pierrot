###
  CLI Main flow
###

# Dependencies
Promise= require 'bluebird'
jsYaml= require 'js-yaml'

pm2= require './pm2'
inquirer= require './inquirer'
mkdirp= require 'mkdirp'
tasks= require './tasks'

fs= require 'fs'
path= require 'path'

# Public
class Manager
  constructor: ->
    process.env.PIERROT_LIB?= __dirname+path.sep
    process.env.PIERROT_CWD?= process.cwd()+path.sep
    process.env.PIERROT_APPS?= process.env.PIERROT_CWD+'apps'+path.sep
    process.env.PIERROT_YAML?= process.env.PIERROT_CWD+'pierrot.yml'

    @yaml= jsYaml.safeLoad fs.readFileSync process.env.PIERROT_YAML,'utf8'

  apps: ->
    return Promise.reject 'not use sudo' if process.getuid() is 0

    prompts= inquirer.getPrompts @yaml.apps,tasks

    mkdirp.sync process.env.PIERROT_APPS

    inquirer.inquiry prompts
    .then (answers)=>
      return Promise.reject 'cancelled' unless answers.really

      Task= tasks[answers.task]
      
      task= new Task @yaml
      task.run answers.apps
      .then (apps)->
        task= answers.task
        successes= []
        failures= []

        for app in apps
          if app.isFulfilled()
            successes.push app.value()
          else
            failures.push app.reason()

        [task,successes,failures]

  vhost: ->
    return Promise.reject 'process isnt root' unless process.getuid() is 0

    script= require.resolve process.env.PIERROT_LIB+'vhost'
    config=
      name: 'VHOST'
      env: process.env

    pm2.deleteAndStart script,config

module.exports.Manager= Manager
