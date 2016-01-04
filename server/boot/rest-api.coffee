module.exports = (server) ->
  restApiRoot = server.get('restApiRoot')
  server.use restApiRoot, server.loopback.rest()
  return
