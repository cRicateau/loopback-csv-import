config        = require '../../config.coffee'

coffee        = require 'gulp-coffee'
concat        = require 'gulp-concat'
gif           = require 'gulp-if'
gulp          = require 'gulp'
gutil         = require 'gulp-util'
ngAnnotate    = require 'gulp-ng-annotate'
sourcemaps    = require 'gulp-sourcemaps'
uglify        = require 'gulp-uglify'

gulp.task 'compile:coffee', ->
  gulp.src config.input.coffee
  .on 'error', gutil.log
  .pipe coffee
    bare: true
  .pipe ngAnnotate()
  .pipe gif config.minify, uglify()
  .pipe concat config.output.application
  .pipe sourcemaps.init()
  .pipe sourcemaps.write()
  .pipe gulp.dest config.output.script
