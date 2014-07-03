'use strict'

angular.module('kg-mvc-example')
  .factory 'logging', ($window, $location) ->
    loggingIsOn = $location.host() isnt 'www.myhost.com'
    _.reduce ['error', 'warn', 'debug', 'info', 'log'], (logger, method)->
      logger[method] = ()-> if loggingIsOn then $window.console[method] arguments
    , {}
