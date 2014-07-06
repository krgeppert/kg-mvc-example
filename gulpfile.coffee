gulp = require 'gulp'
watch = require 'gulp-watch'
livereload = require 'gulp-livereload'
plumber = require 'gulp-plumber'
stylus = require 'gulp-stylus'
jade = require 'gulp-jade'
coffee = require 'gulp-coffee'
karma = require 'gulp-karma'
nib = require 'nib'
buildIndex = require './scripts/build-index'
doIt = require './scripts/gulp-doit'
componentConfig = require './scripts/dev-regex.coffee'
del = require 'del'
connect = require 'gulp-connect'

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
    .pipe(coffee({bare:true}).on('error', console.log))
    .pipe(gulp.dest('./build/js'))

gulp.task 'build-css', ()->
  gulp.src(componentConfig.styles.regexes)
    .pipe(stylus().on('error', console.log))
    .pipe(gulp.dest('./build/css'))

gulp.task 'build-html', ()->
  gulp.src(componentConfig.templates.regexes)
    .pipe(jade({use: [nib()]}).on('error', console.log))
    .pipe(gulp.dest('./build/templates'))

gulp.task 'build-tests', ()->
  gulp.src(componentConfig.test.regexes)
    .pipe(coffee({bare:true}).on('error', console.log))
    .pipe(gulp.dest('./build/test'))

gulp.task 'watch', ['build-dev'], (cb)->
  gulp.src('./app/index.html', {read:false})
    .pipe(watch())
    .pipe(plumber())
    .pipe(doIt(buildIndex))
    .pipe(livereload())

  gulp.src(componentConfig.scripts.regexes, {read:false})
    .pipe(watch())
    .pipe(plumber())
    .pipe(coffee({bare:true}).on('error', console.log))
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

gulp.task 'test', ['build-tests', 'build-js'], ()->
  gulp.src('./build/test/*.js')
    .pipe(karma({
      configFile: 'karma.conf.coffee'
      action: 'run'
    })).on 'error', (err)->
      throw err

gulp.task 'develop', ['watch', 'build-index'], ()->
  connect.server
    root: 'build'
    port: 5050


# TODO: recognize file name changes, recognize added files.