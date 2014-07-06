
module.exports = (config)->
  config.set

    # base path, that will be used to resolve files and exclude
    basePath: './'

    # testing framework to use (jasmine/mocha/qunit/...)
    frameworks: ['mocha']

    # list of files / patterns to load in the browser
    files: [
      'test/assert.js'
      'test/jQuery.js'
      'test/angular.js'
      'test/angular-route.js'
      'test/angular-mocks.js'
      'test/lodash.js'
      'build/js/*.js'
      'build/test/*.js'
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
