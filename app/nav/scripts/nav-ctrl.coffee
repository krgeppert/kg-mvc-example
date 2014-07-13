'use strict'

angular.module('kgapp')
  .controller 'NavCtrl', ($scope, logger) ->
    $scope.log = (message)->
      return message