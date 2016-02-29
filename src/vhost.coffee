###
  Virtual host program via `$ pierrot vhost`
###

# Dependencies
jsYaml= require 'js-yaml'

fs= require 'fs'
bouncy= require 'bouncy'

# Private
yaml= jsYaml.safeLoad fs.readFileSync process.env.PIERROT_YAML,'utf8'

# Main
requestListener= (req,res,bounce)->
  for name,config of yaml.apps when config.from is req.headers.host
    return bounce config.to unless typeof config.to is 'string'
    
    schema= unless req.connection.encrypted? then 'http://' else 'https://'

    uri= config.to
    uri= schema+uri unless uri[0...4] is 'http'
    uri+= req.url

    res.writeHead 302,{Location:uri}
    res.end()
    return

  for name,config of yaml.apps when config.wildcard
    continue unless req.headers.host.slice(-config.from.length) is config.from
    return bounce config.to

  # https://github.com/substack/bouncy/issues/57#issuecomment-29421435
  req.connection._bouncyStream._handled= false
  res.statusCode= 404
  res.end 'no such host'

bouncy(requestListener).listen 80,->
  try
    process.setuid 500 if process.getuid() is 0
  catch error
    console.error error.stack

  console.log "PIERROT_VHOST listening at http://localhost:80/"

if yaml.key and yaml.cert
  return console.warn "Not exists `#{yaml.key}` skip." unless fs.existsSync yaml.key

  bouncy
    key: fs.readFileSync yaml.key
    cert: fs.readFileSync yaml.cert
  ,requestListener

  .listen 443,->
    try
      process.setuid 500 if process.getuid() is 0
    catch error
      console.error error.stack

    console.log "PIERROT_VHOST listening at http://localhost:443/"
