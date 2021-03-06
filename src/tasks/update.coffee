# Dependencies
Promise= require 'bluebird'
Task= require '../task'

# Public
class Update extends Task
  run: (apps)->
    Promise.settle(
      for name in apps when @yaml.apps[name]?.repo
        config= @yaml.apps[name]

        do (name,config)=>
          @pull name,config
          .then =>
            @install name,config
            
          .then =>
            @promise 'reload',name

          .then ->
            name
            
    )

module.exports= Update
