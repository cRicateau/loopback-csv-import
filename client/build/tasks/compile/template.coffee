config        = require '../../config.coffee'

gulp          = require 'gulp'
gutil         = require 'gulp-util'
jade          = require 'gulp-jade'
sourcemaps    = require 'gulp-sourcemaps'
templateCache = require 'gulp-angular-templatecache'

gulp.task 'compile:template', ->
  gulp.src config.input.template
  .on 'error', gutil.log
  .pipe jade
    doctype: 'html'
    pretty: not config.minify
  .pipe templateCache
    filename: config.output.template.filename
    module: config.output.template.module
    standalone: true
  .pipe sourcemaps.init()
  .pipe sourcemaps.write()
  .pipe gulp.dest config.output.script
