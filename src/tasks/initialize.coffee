# Dependencies
Promise= require 'bluebird'
Task= require '../task'

# Public
class Reset extends Task
  run: (apps)->
    Promise.settle(
      for name in apps when @yaml.apps[name]?.repo
        config= @yaml.apps[name]

        do (name,config)=>
          @rimraf process.env.PIERROT_APPS+name
          .then =>
            @clone name,config

          .then =>
            @install name,config

          .then =>
            @deleteAndStart name,config

          .then ->
            name
            
    )

module.exports= Reset
