
module.exports = (config)->
  config.set

    # base path, that will be used to resolve files and exclude
    basePath: './'

    # testing framework to use (jasmine/mocha/qunit/...)
    frameworks: ['mocha']

    # list of files / patterns to load in the browser
    files: [
      "bower_components/assert/assert.js"
      "bower_components/jquery/dist/jquery.min.js"
      "bower_components/angular/angular.min.js"
      "bower_components/angular-route/angular-route.min.js"
      "bower_components/angular-mocks/angular-mocks.js"
      "bower_components/lodash/dist/lodash.min.js"
      "bower_components/d3/d3.min.js"
      "dev/js/**/*.js"
      "tests/**/*.js"
    ]

    # list of files / patterns to exclude
    exclude: []

    # web server port
    port: 9000

    # level of logging
    # possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
    logLevel: config.LOG_WARN


    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: false


    # Start these browsers, currently available:
    # - Chrome
    # - ChromeCanary
    # - Firefox
    # - Opera
    # - Safari (only Mac)
    # - PhantomJS
    # - IE (only Windows)
    browsers: ['PhantomJS']

    plugins: [
      'karma-phantomjs-launcher'
      'karma-firefox-launcher'
      'karma-ie-launcher'
      'karma-chrome-launcher'
      'karma-mocha'
    ]


    # Continuous Integration mode
    # if true, it capture browsers, run tests and exit
    singleRun: true
