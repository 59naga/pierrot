# Dependencies
Promise= require 'bluebird'
Task= require '../task'

# Public
class DeleteAndStart extends Task
  run: (apps)->
    Promise.settle(
      for name in apps when @yaml.apps[name]?.repo
        config= @yaml.apps[name]

        do (name,config)=>
          @deleteAndStart name,config

          .then ->
            name
            
    )

module.exports= DeleteAndStart
