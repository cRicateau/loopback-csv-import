config        = require '../../config.coffee'

gulp          = require 'gulp'
jade          = require 'gulp-jade'
gutil         = require 'gulp-util'

gulp.task 'compile:jade', ->
  gulp.src config.input.jade
  .on 'error', gutil.log
  .pipe jade
    pretty: not config.minify
  .pipe gulp.dest config.output.path
