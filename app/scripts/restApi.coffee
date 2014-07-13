angular.module('kgapp').factory 'restApi', ($http, $q, config)->
  get: (url)->
    window.mocks ?= {}
    if config.devMode() and not window.mocks[url] then return $http.get config.getBaseUrl() + url
    else
      deferred = $q.defer()
      setTimeout ->
        deferred.resolve window.mocks[url]
      deferred.promise

