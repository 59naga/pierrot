###
  promise-based pm2 methods
###

# Dependencies
Promise= require 'bluebird'
pm2= Promise.promisifyAll(require 'pm2')
pm2Bin= require.resolve 'pm2/bin/pm2'

spawn= (require 'child_process').spawn

class Pm2
  bin: pm2Bin
  __proto__: pm2
  
  deleteAndStart: (script,config)->
    @deleteAsync script,config
    .catch (error)->
      console.error error.msg ? error

    .then =>
      @startAsync script,config

    .then ->
      config.name

  list: ->
    new Promise (resolve,reject)=>
      child= spawn @bin,['list'],{stdio:'inherit'}
      child.on 'close',resolve
      child.on 'error',reject

module.exports= new Pm2
