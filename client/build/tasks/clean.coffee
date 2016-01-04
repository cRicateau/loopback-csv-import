config        = require '../config.coffee'

del           = require 'del'
gulp          = require 'gulp'
vinylPaths    = require 'vinyl-paths'

gulp.task 'clean', ->
  gulp.src config.output.path
  .pipe vinylPaths del
