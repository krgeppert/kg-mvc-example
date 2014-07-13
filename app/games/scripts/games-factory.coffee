angular.module('kgapp')
  .factory 'games', ($stateParams, restApi)->
    games = {}
    restApi.get("/admin/team/#{$stateParams.cloudId}}/games").then (response)->
      _.extend games, _.indexBy(response, 'gameId')
    games