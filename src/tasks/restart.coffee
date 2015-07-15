# Dependencies
Promise= require 'bluebird'
Task= require '../task'

# Public
class Restart extends Task
  execute: (apps)->
    Promise.resolve()
    .then =>
      Promise.settle(
        for name in apps
          @restart name
      )

module.exports= Restart
