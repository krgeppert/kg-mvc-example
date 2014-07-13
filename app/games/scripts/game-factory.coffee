angular.module('kgapp')
  .factory 'game', ($stateParams, restApi)->
    game = {}
    restApi.get("/team/#{$stateParams.cloudId}/game/#{$stateParams.gameId}").then (response)->
      _.extend game, response
    game