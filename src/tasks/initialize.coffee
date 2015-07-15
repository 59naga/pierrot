# Dependencies
Promise= require 'bluebird'
Task= require '../task'

# Public
class Reset extends Task
  execute: (apps)->
    Promise.resolve()
    .then =>
      Promise.settle(
        for name in apps when @yaml.apps[name]?.repo
          @rimraf process.env.PIERROT_APPS+name
      )

    .then =>
      Promise.settle(
        for name in apps
          @clone name,@yaml.apps[name]
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

module.exports= Reset
