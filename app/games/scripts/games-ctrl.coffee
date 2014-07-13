"use strict"

angular.module('kgapp')
  .controller 'GamesCtrl', ($scope, games) ->
    $scope.games = games
