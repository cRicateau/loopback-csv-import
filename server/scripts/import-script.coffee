server = require '../server.coffee'
options = JSON.parse process.argv[2]

try
  server.models[options.model].import options.container, options.file, options, (err) ->
    console.error err if err
    process.exit if err then 1 else 0
catch err
  console.error err
  process.exit if err then 1 else 0
  
