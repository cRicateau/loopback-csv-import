config        = require '../../config.coffee'

coffee        = require 'gulp-coffee'
concat        = require 'gulp-concat'
gif           = require 'gulp-if'
gulp          = require 'gulp'
rename	      = require 'gulp-rename'
util          = require 'gulp-util'
lbService     = require 'gulp-loopback-sdk-angular'
ngAnnotate    = require 'gulp-ng-annotate'
sourcemaps    = require 'gulp-sourcemaps'
uglify        = require 'gulp-uglify'

gulp.task 'compile:loopback', ->
  return if not config.input.loopback.enabled
  gulp.src config.input.loopback.server
  .on 'error', util.log
  .pipe lbService apiUrl: config.input.loopback.url
  .pipe uglify()
  .pipe sourcemaps.init()
  .pipe sourcemaps.write()
  .pipe rename config.output.loopback.filename
  .pipe gulp.dest config.output.loopback.path
