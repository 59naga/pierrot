# Define pierrot tasks
# key : description
# value : class ::run promise factory

module.exports=
  'reload':
    require './reload'

  'update':
    require './update'

  'deleteAndStart':
    require './delete-and-start'

  'initialize':
    require './initialize'
