gulp = require 'gulp'
watch = require 'gulp-watch'
livereload = require 'gulp-livereload'
plumber = require 'gulp-plumber'
filter = require 'gulp-filter'
stylus = require 'gulp-stylus'
jade = require 'gulp-jade'
coffee = require 'gulp-coffee'
nib = require 'nib'
utils = require 'util'
buildIndex = require './scripts/build-index'

gulp.task 'default', ()->
  util.log 'No default set.'

gulp.task 'develop', ()->

  buildIndex().then ()-> utils.log 'build/index.html built.'

  gulp.src('./app/**/*.coffee')
    .pipe(watch())
    .pipe(plumber())
    .pipe(coffee().on('error', console.log))
    .pipe(gulp.dest('./build/js'))
    .pipe(livereload())

  gulp.src('./app/**/*.styl')
    .pipe(watch())
    .pipe(plumber())
    .pipe(stylus().on('error', console.log))
    .pipe(gulp.dest('./build/css'))
    .pipe(livereload())

  gulp.src(['./app//**/*.jade'])
    .pipe(watch())
    .pipe(plumber())
    .pipe(jade({use: [nib()]}).on('error', console.log))
    .pipe(gulp.dest('./build/templates'))
    .pipe(livereload())


