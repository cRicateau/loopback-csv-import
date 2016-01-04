helmet  = require 'helmet'
hpp     = require 'hpp'

module.exports = (server) ->
  if process.env.NODE_ENV isnt 'test'
    # Helmet for security
    server.use helmet.frameguard()
    server.use helmet.xssFilter()
    server.use helmet.hsts
      maxAge: 10 * 365 * 24 * 60 * 60 * 1000
      includeSubdomains: true
      preload: true
    server.use helmet.ieNoOpen()
    # These two lines causes display issues on IE
    # That's why they're commented
    #server.use helmet.noCache()
    #server.use helmet.noSniff()

    # HPP protect against HTTP Parameter Pollution attacks
    server.use hpp()
  return
