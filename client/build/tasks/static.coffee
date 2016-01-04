config        = require '../config.coffee'

gulp          = require 'gulp'

gulp.task 'static', ->
  for type of config.input.static
    if type of config.output.static
      gulp.src config.input.static[type]
      .pipe gulp.dest config.output.static[type]
