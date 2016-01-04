module.exports = (server) ->
  explorer = undefined
  try
    explorer = require('loopback-explorer')
  catch err
    # Print the message only when the app was started via `server.listen()`.
    # Do not print any message when the project is used as a component.
    server.once 'started', (baseUrl) ->
      console.log 'Run `npm install loopback-explorer` to enable the LoopBack explorer'
      return
    return
  restApiRoot = server.get('restApiRoot')
  explorerApp = explorer server,
    basePath: "#{server.settings.baseUri}#{restApiRoot}"
  server.use '/explorer', explorerApp
  server.once 'started', ->
    baseUrl = server.get('url').replace(/\/$/, '')
    # express 4.x (loopback 2.x) uses `mountpath`
    # express 3.x (loopback 1.x) uses `route`
    explorerPath = explorerApp.mountpath or explorerApp.route
    console.log 'Browse your REST API at %s%s', baseUrl, explorerPath
    return
  return
