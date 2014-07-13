'use strict'

angular.module('kgapp')
  .controller 'NavCtrl', ($scope, logger, teams, $state) ->
    $scope.teams = teams