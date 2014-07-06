'use strict'

angular.module('kgapp')
  .factory 'logger', ($window, $location) ->
    loggingIsOn = true
    _.reduce ['error', 'warn', 'debug', 'info', 'log'], (logger, method)->
      logger[method] = ()-> if loggingIsOn then $window.console[method] arguments
      logger
    , {}

