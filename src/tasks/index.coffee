# Define pierrot tasks
# key : description
# value : class ::run promise factory

module.exports=
  'update         e.g. $ git pull && npm install --production && pm2 reload':
    require './update'

  'deleteAndStart e.g. $ pm2 start # using pierrot.yml':
    require './delete-and-start'

  'initialize     e.g. $ rm -rf && git clone && npm install --production && pm2 start':
    require './initialize'
