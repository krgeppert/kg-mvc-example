'use strict'

angular.module('kgapp')
  .factory 'logger', ($window, $location, config) ->
    _.reduce ['error', 'warn', 'debug', 'info', 'log'], (logger, method)->
      logger[method] = ()-> if config.loggingIsOn() then $window.console[method] arguments
      logger
    , {}

