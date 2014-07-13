"use strict"

angular.module('kgapp')
  .factory 'teams', (restApi)->
    teams = {}
    restApi.get('/teams').then (response)->
      _.extend teams, _.indexBy(response, 'cloudId')
    teams