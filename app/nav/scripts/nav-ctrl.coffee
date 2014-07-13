'use strict'

angular.module('kgapp')
  .controller 'NavCtrl', ($scope, logger, teams, $state) ->
    $scope.teams = teams
    $scope.logout = ()->
      alert 'waiting for api support for this.'