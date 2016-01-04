require('coffee-script/register');

var gulp    = require('gulp');
var builder = require('webapp-gulp-builder');

var config = require('./gulp.config.coffee');

builder(gulp, config);
