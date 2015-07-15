# Dependencies
Promise= require 'bluebird'
Task= require '../task'

# Public
class Update extends Task
  execute: (apps)->
    Promise.resolve()
    .then =>
      Promise.settle(
        for name in apps when @yaml.apps[name]?.repo
          @pull name,@yaml.apps[name]
      )

    .then =>
      Promise.settle(
        for name in apps
          @install name,@yaml.apps[name]
      )

    .then =>
      Promise.settle(
        for name in apps
          @deleteAndStart name,@yaml.apps[name]
      )

module.exports= Update
