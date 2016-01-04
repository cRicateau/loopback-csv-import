config        = require '../../config.coffee'

autoprefixer  = require 'gulp-autoprefixer'
gif           = require 'gulp-if'
gulp          = require 'gulp'
gutil         = require 'gulp-util'
less          = require 'gulp-less'
minifyCss     = require 'gulp-minify-css'
path          = require 'path'

gulp.task 'compile:less', ->
  gulp.src config.input.less.main
  .on 'error', gutil.log
  .pipe less paths: [ path.join(__dirname) ]
  .pipe autoprefixer
    browsers: ['last 2 versions']
    cascade: false
  .pipe gif config.minify, minifyCss()
  .pipe gulp.dest config.output.less
