config          = require '../../config.coffee'

concat          = require 'gulp-concat'
filter          = require 'gulp-filter'
gif             = require 'gulp-if'
gulp            = require 'gulp'
gutil           = require 'gulp-util'
mainBowerFiles  = require 'main-bower-files'
sourcemaps      = require 'gulp-sourcemaps'
uglify          = require 'gulp-uglify'

gulp.task 'compile:vendor', ->
  gulp.src mainBowerFiles()
  .on 'error', gutil.log
  .pipe filter '**/*.js'
  .pipe concat config.output.vendor
  .pipe gif config.minify, uglify()
  .pipe sourcemaps.init()
  .pipe sourcemaps.write()
  .pipe gulp.dest config.output.script
