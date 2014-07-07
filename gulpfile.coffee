
_ = require 'lodash'
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
filter = require 'gulp-filter'
runSequence = require 'run-sequence'

gulp.task 'build-dist', (callback)->
  runSequence ['clean-dist', 'clean-temp']
    , ['minify-js','minify-css','compile-jade-dist','copy-images-dist']
    , 'build-dist-index'
    , callback

gulp.task 'build-dev', (callback)->
  runSequence 'clean-dev'
    , 'copy-bower'
    , ['compile-coffee-dev','compile-stylus-dev','compile-jade-dev','copy-images-dev']
    , 'build-dev-index'
    , callback

_.each ['dist', 'dev'], (env)->

  if env is 'dist' then dir = 'temp' else dir = 'dev'

  gulp.task "build-#{env}-index", (cb)->
    buildIndex(env).then ->
      cb()
    false

  gulp.task "clean-#{env}", (cb)->
    del ["./#{env}/**/*"], cb

  gulp.task "copy-images-#{env}", ()->
    gulp.src(componentConfig.images.regexes)
      .pipe(gulp.dest("./#{env}/images"))

  gulp.task "compile-jade-#{env}", ()->
    gulp.src(componentConfig.templates.regexes)
      .pipe(jade().on('error', console.log))
      .pipe(gulp.dest("./#{env}/templates"))

  gulp.task "connect-#{env}", ()->
    connect.server
      root: env
      port: 5050

_.each ['dev', 'temp'], (dir)->
  gulp.task "copy-css-#{dir}", ()->
    gulp.src(componentConfig.css.regexes)
      .pipe(gulp.dest("./#{dir}/css"))

  gulp.task "compile-coffee-#{dir}", ()->
    gulp.src(componentConfig.scripts.regexes)
      .pipe(coffee({bare:true}).on('error', console.log))
      .pipe(gulp.dest("./#{dir}/js"))

  gulp.task "compile-stylus-#{dir}", ()->
    gulp.src(componentConfig.styles.regexes)
      .pipe(stylus().on('error', console.log))
      .pipe(gulp.dest("./#{dir}/css"))


gulp.task 'minify-css', ['compile-stylus-temp', 'copy-css-temp'] ,()->
  gulp.src('./temp/css/**/*.css')
    .pipe(cssmin())
    .pipe(concat('main.css'))
    .pipe(gulp.dest('./dist'))

gulp.task 'minify-js', ['compile-coffee-temp'],()->
  gulp.src('./temp/js/**/*.js')
    .pipe(ngmin())
    .pipe(concat('main.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./dist'))

gulp.task 'copy-bower', ()->
  gulp.src('./bower_components/**/*.js')
    .pipe(gulp.dest('./dev/bower_components'))

gulp.task "clean-temp", (cb)->
  del ["./temp/**/*"], cb

gulp.task 'dev-watch',  (callback)->
  runSequence ['watch-index', 'watch-coffee', 'watch-jade', 'watch-stylus', 'watch-images']
  , 'live-reload'
  , callback

gulp.task 'watch-index', ()->
  gulp.src('./app/index.html', {read:false})
    .pipe(watch())
    .pipe(plumber())
    .pipe(doIt(_.bind(gulp.start, gulp), 'build-dev-index'))

gulp.task 'watch-coffee', ()->
  gulp.src(componentConfig.scripts.regexes, {read:false})
    .pipe(watch())
    .pipe(plumber())
    .pipe(coffee({bare:true}).on('error', console.log))
    .pipe(gulp.dest('./dev/js'))

  watch({glob: componentConfig.scripts.regexes})
    .pipe(filter(isAdded))
    .pipe(plumber())
    .pipe(coffee({bare:true}).on('error', console.log))
    .pipe(gulp.dest("./dev/js"))
    .pipe(doIt(_.bind(gulp.start, gulp), 'build-dev-index'))


gulp.task 'watch-stylus', ()->
  gulp.src(componentConfig.styles.regexes, {read:false})
    .pipe(watch())
    .pipe(plumber())
    .pipe(stylus().on('error', console.log))
    .pipe(gulp.dest('./dev/css'))

  watch({glob: componentConfig.styles.regexes})
    .pipe(filter(isAdded))
    .pipe(plumber())
    .pipe(stylus().on('error', console.log))
    .pipe(gulp.dest('./dev/css'))
    .pipe(doIt(_.bind(gulp.start, gulp), 'build-dev-index'))

gulp.task 'watch-jade', ()->
  gulp.src(componentConfig.templates.regexes, {read:false})
    .pipe(watch())
    .pipe(plumber())
    .pipe(jade({use: [nib()]}).on('error', console.log))
    .pipe(gulp.dest('./dev/templates'))

  watch({glob: componentConfig.templates.regexes})
    .pipe(filter(isAdded))
    .pipe(plumber())
    .pipe(jade({use: [nib()]}).on('error', console.log))
    .pipe(gulp.dest('./dev/templates'))

gulp.task 'watch-images', ()->
  gulp.src(componentConfig.templates.regexes, {read:false})
    .pipe(watch())
    .pipe(plumber())
    .pipe(gulp.dest('./dev/images'))

  watch({glob: componentConfig.images.regexes})
  .pipe(filter(isAdded))
  .pipe(plumber())
  .pipe(gulp.dest('./dev/images'))

gulp.task 'live-reload', ()->
  watch({glob: 'dev/**/*'})
    .pipe(plumber())
    .pipe(livereload())

gulp.task 'compile-tests', ()->
  gulp.src(componentConfig.test.regexes)
    .pipe(coffee({bare:true}).on('error', console.log))
    .pipe(gulp.dest('./tests'))

gulp.task 'clean-tests', (cb)->
  del ['./tests/**/*'], cb

gulp.task 'run-tests', ()->
  gulp.src('./tests/**/*')
    .pipe(karma({
      configFile: 'karma.conf.coffee'
      action: 'run'
    })).on 'error', (err)->
      console.log err

gulp.task 'test-build',  (callback)->
  runSequence ['clean-tests', 'clean-dev'], ['compile-tests', 'compile-js-dev'], 'run-tests', callback

gulp.task 'test', (callback)->
  runSequence 'clean-tests', 'build-tests', 'run-tests', callback

gulp.task 'develop', (callback)->
  runSequence ['build-dev', 'compile-tests']
    , 'dev-watch'
    , ['run-tests', 'connect-dev']
    , callback

isAdded = (file)->
  file.event is 'added'
# TODO: recognize file name changes, recognize added files.