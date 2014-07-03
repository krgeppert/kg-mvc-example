(function() {
  'use strict';
  angular.module('kg-mvc-example').factory('auth', function($q) {
    var deferred;
    deferred = $q.defer();
    setTimeout(function() {
      return deferred.resolve(Math.random().toString().slice('2,4') === '100');
    }, 10);
    return deferred.promise;
  });

}).call(this);
