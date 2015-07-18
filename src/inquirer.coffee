###
  Promise-based inquirer methods
###

# Dependencies
Promise= require 'bluebird'
inquirer= require 'inquirer'

fs= require 'fs'
path= require 'path'

# Private
cacheName= path.join process.cwd(),'.pierrotrc'
cache=
  try
    JSON.parse fs.readFileSync cacheName
  catch
    fs.writeFileSync cacheName,'{}'
    JSON.parse fs.readFileSync cacheName

# Public
class Inquirer
  inquiry: (prompts)->
    new Promise (resolve)->
      inquirer.prompt prompts,(answers)->
        fs.writeFileSync cacheName,JSON.stringify answers,null,2
        
        resolve answers

  getPrompts: (apps,commands)->
    appNames= (name for name,config of apps)
    commandNames= (name for name,command of commands)

    [
      {
        name: 'apps'
        
        type: 'checkbox'
        message: 'apps'
        choices: appNames
        default: cache.apps
        validate: (apps)->
          if apps.length
            true
          else
            'not selected (Press <space> to select)'
      }
      {
        name: 'task'

        type: 'list'
        message: 'task'
        choices: commandNames
        default: cache.task
      }
      {
        name: 'really'

        type: 'confirm'
        message: 'really'
        default: true
      }
    ]

module.exports= new Inquirer
