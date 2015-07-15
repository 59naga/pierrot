###
  Argument parsing & cli reporting
###

# Dependencies
version= (require '../package').version

Command= (require 'commander').Command
manager= require './manager'
pm2= require './pm2'

spawn= (require 'child_process').spawn

# Public
class Pierrot extends Command
  constructor: ->
    super

    @version version
    @usage '<command>'

    @command 'apps'
    .alias 'a'
    .description 'Provide applications using ./pierrot.yml'
    .action ->
      pm2.connectAsync()
      .then ->
        manager.apps()

      .spread (task,successes,failures)->
        console.log ''
        console.log '%s was successfully the `%s`', name, task for name in successes
        console.error '%s was failure: %s', name, message for {name,message} in failures
        console.log ''
      
      .then ->
        pm2.list()

      .catch (error)->
        console.log error

      .finally ->
        pm2.disconnect()

    @command 'vhost'
    .alias 'v'
    .description 'host routing for applications'
    .action ->
      pm2.connectAsync()

      .then ->
        manager.vhost()

      .then ->
        pm2.list()

      .then (answers)->
        console.log ''
        console.log 'successfully `vhost`.'
        console.log ''
        console.log '  Please fix:'
        console.log ''
        console.log '  $ sudo chmod -R 777 ~/.pm2'
        console.log ''
        console.log '  See: https://github.com/Unitech/PM2/issues/837'
        console.log ''

      .finally ->
        pm2.disconnect()

    @command 'pm2 [cmd...]'
    .alias 'p'
    .description 'call local installed pm2'
    .action (cmd)->
      spawn pm2.bin,cmd,{stdio:'inherit'}

  parse: ->
    super

    invalid= (arg for arg in @args when typeof arg is 'string').length
    if invalid
      console.error ''
      console.error '  command not found'
      console.error ''

    @outputHelp() if invalid or @args.length is 0

module.exports= new Pierrot
module.exports.Pierrot= Pierrot
