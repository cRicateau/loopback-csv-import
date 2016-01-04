server = require '../server.coffee'
options = JSON.parse process.argv[2]

try
  server.models.Invoice.import options.container, options.file, options, (err) ->
    process.exit if err then 1 else 0
catch err
  process.exit if err then 1 else 0