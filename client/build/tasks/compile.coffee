gulp          = require 'gulp'
requireDir    = require 'require-dir'

requireDir './compile'

gulp.task 'compile', [
  'compile:coffee'
  'compile:less'
  'compile:jade'
  'compile:template'
  'compile:vendor'
  'compile:loopback'
]
