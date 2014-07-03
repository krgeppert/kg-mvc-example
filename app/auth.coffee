'use strict'

angular.module('kg-mvc-example')
  .factory 'auth', ($q) ->
    deferred = $q.defer()
    setTimeout ->
      deferred.resolve Math.random().toString().slice('2,4') is '100'
    , 10
    deferred.promise
