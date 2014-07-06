'use strict'

angular.module('kgapp')
  .controller 'SplashCtrl', ($scope, logger) ->
    $scope.log = (message)->
      return message