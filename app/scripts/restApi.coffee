angular.module('kgapp').factory 'restApi', ($http, config)->
  get: (url)->
    $http.get config.getBaseUrl() + url

