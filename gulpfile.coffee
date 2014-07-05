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
doIt = require './scripts/gulp-doit'
orchestrator = require 'orchestrator'
debug = require 'gulp-debug'
componentConfig = require './scripts/dev-regex.coffee'
del = require 'del'
open = require 'gulp-open'

gulp.task 'default', ()->
  util.log 'No default set.'

gulp.task 'clean', (cb)->
  del ['./build/*/*'], cb

gulp.task 'build-index',['build-dev'], (cb)->
  buildIndex()
  cb()

gulp.task 'build-dev', ['build-js', 'build-css', 'build-html'], ()->

gulp.task 'build-js', ()->
  gulp.src(componentConfig.scripts.regexes)
    .pipe(coffee().on('error', console.log))
    .pipe(gulp.dest('./build/js'))

gulp.task 'build-css', ()->
  gulp.src(componentConfig.styles.regexes)
    .pipe(stylus().on('error', console.log))
    .pipe(gulp.dest('./build/css'))

gulp.task 'build-html', ()->
  gulp.src(componentConfig.templates.regexes)
    .pipe(jade({use: [nib()]}).on('error', console.log))
    .pipe(gulp.dest('./build/templates'))

gulp.task 'watch', ['build-dev'], (cb)->

  gulp.src(componentConfig.scripts.regexes, {read:false})
    .pipe(watch())
    .pipe(plumber())
    .pipe(coffee().on('error', console.log))
    .pipe(gulp.dest('./build/js'))
    .pipe(livereload())

  gulp.src(componentConfig.styles.regexes, {read:false})
    .pipe(watch())
    .pipe(plumber())
    .pipe(stylus().on('error', console.log))
    .pipe(gulp.dest('./build/css'))
    .pipe(livereload())

  gulp.src(componentConfig.templates.regexes, {read:false})
    .pipe(watch())
    .pipe(plumber())
    .pipe(jade({use: [nib()]}).on('error', console.log))
    .pipe(gulp.dest('./build/templates'))
    .pipe(livereload())

  cb()

gulp.task 'develop', ['watch', 'build-index'], ()->
  gulp.src("./build/index.html")
    .pipe(debug())
    .pipe(open())
