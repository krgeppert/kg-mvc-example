(function() {
  'use strict';
  angular.module('kg-mvc-example').factory('logging', function($window, $location) {
    var loggingIsOn;
    loggingIsOn = $location.host() !== 'www.myhost.com';
    return _.reduce(['error', 'warn', 'debug', 'info', 'log'], function(logger, method) {
      return logger[method] = function() {
        if (loggingIsOn) {
          return $window.console[method](arguments);
        }
      };
    }, {});
  });

}).call(this);
