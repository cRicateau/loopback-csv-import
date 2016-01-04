config        = require '../config.coffee'

gulp          = require 'gulp'

require './clean.coffee'
require './compile.coffee'
require './static.coffee'

gulp.task 'default', ['compile', 'static'], ->
  if config.input.loopback.enabled
    # To close database with loopback
    process.exit 0
