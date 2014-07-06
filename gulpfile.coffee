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
ngmin = require 'gulp-ngmin'
cssmin = require 'gulp-cssmin'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
debug = require 'gulp-debug'


gulp.task 'build', ['clean-dist','minify-js','minify-css','copy-html','copy-images-prod'], (cb)->
  buildIndex('dist').then (err)->
    if err then throw err
    cb()
  false

gulp.task 'build-dev', ['clean-build','build-js', 'build-css', 'build-html', 'copy-css']

gulp.task 'build-index', ['build-dev'], ()->
  buildIndex('dev').then ->
    cb()
  false


gulp.task 'clean-dist', (cb)->
  del ['./dist/**/*'], cb

gulp.task 'clean-build', (cb)->
  del ['./build/**/*'], cb

gulp.task 'copy-images', ()->
  gulp.src(componentConfig.images.regexes)
    .pipe(gulp.dest('./build/images'))

gulp.task 'copy-images-prod', ()->
  gulp.src('./build/images')
    .pipe(gulp.dest('./dist/images'))

gulp.task 'minify-css', ['build-css', 'copy-css'] ,()->
  gulp.src('./build/**/*.css')
    .pipe(cssmin())
    .pipe(concat('main.css'))
    .pipe(gulp.dest('./dist'))

gulp.task 'minify-js', ['build-js'],()->
  gulp.src('./build/**/*.js')
    .pipe(ngmin())
    .pipe(concat('main.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./dist'))

gulp.task 'copy-html', ['build-html'],()->
  gulp.src('./build/templates/**/*.html')
    .pipe(gulp.dest('./dist/templates'))

gulp.task 'copy-css', ()->
  gulp.src(componentConfig.css.regexes)
    .pipe(gulp.dest('./build/css'))

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
    .pipe(gulp.dest('./tests'))

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
      console.log err

gulp.task 'develop', ['watch', 'build-index'], ()->
  console.log 'woo?'
  connect.server
    root: 'build'
    port: 5050


# TODO: recognize file name changes, recognize added files.