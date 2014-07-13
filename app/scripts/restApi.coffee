angular.module('kgapp').factory 'restApi', ($http, $q, config)->
  get: (url)->
    window.mocks ?= {}
    for mockUrl, mock of window.mocks
      regex = new RegExp mockUrl
      if regex.test(url)
        deferred = $q.defer()
        setTimeout ->
          deferred.resolve mock
        return deferred.promise
    $http.get config.getBaseUrl() + url

