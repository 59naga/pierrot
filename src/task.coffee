###
  utility of tasks
###

# Dependencies
pm2= require './pm2'

Promise= require 'bluebird'
rimraf= Promise.promisify require 'rimraf'

path= require 'path'
spawn= (require 'child_process').spawn

# Public
class Task
  constructor: (@yaml)->

  rimraf: ->
    rimraf arguments...

  clone: (name,config)->
    return Promise.resolve() unless config.repo

    command= "git clone #{config.repo} #{name}"
    options=
      cwd: process.env.PIERROT_APPS

    @spawnAsync command,options

  pull: (name,config)->
    return Promise.resolve() unless config.repo

    command= 'git pull'
    options=
      cwd: process.env.PIERROT_APPS+name

    @spawnAsync command,options

  install: (name,config)->
    return Promise.resolve() unless config.repo

    command= 'npm install --production'
    options=
      cwd:process.env.PIERROT_APPS+name

    @spawnAsync command,options

  spawnAsync: (command,options={})->
    [bin,args...]= command.split /\s+/

    options.cwd?= process.env.PIERROT_CWD
    # options.stdio?= 'inherit'
    cwd= path.relative process.env.PIERROT_CWD,options.cwd
    console.log '%s: %s',cwd,command

    new Promise (resolve,reject)->
      child= spawn bin,args,options
      child.on 'close',resolve
      child.on 'error',reject

  deleteAndStart: (name,config)->
    cwd= path.relative process.env.PIERROT_CWD, process.env.PIERROT_APPS+name
    console.log '%s: delete and start pm2 process', cwd

    try
      script= require.resolve process.env.PIERROT_APPS+name
    catch error
      return Promise.reject {name:name, message:error.message}

    # transform arguments to pm2.start options
    config.name?= name
    config.cwd?=
      if config.repo
        process.env.PIERROT_APPS+name
      else
        # eg {script: "./apps/standalone.coffee", cwd: "./"}
        process.env.PIERROT_CWD

    config.env?= {}
    config.env.PORT?= config.to
    config.env.NODE_ENV?= 'production'
    delete config.repo
    delete config.from
    delete config.to

    pm2.deleteAndStart script,config

  promise: (method,name)->
    pm2[method+'Async'] name
    .catch (error)->
      Promise.reject {name:name, message:error.message ? 'not started'}

module.exports= Task
