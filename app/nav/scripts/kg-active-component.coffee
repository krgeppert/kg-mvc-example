"use strict"

angular.module('kgapp')
  .directive 'kgActive', () ->
    restrict: 'A'
    scope:
      kgActive: '='
    link: (scope, element, attributes)->
      children = element.children()

      selected = _.find children, (child)->
        _.contains child.className, "default-active"

      unless selected then selected = _.first children

      selected = angular.element selected

      selected.addClass scope.kgActive
      _.each element.children(), (elem)->
        angular.element(elem).on 'click', ->
          selected.removeClass scope.kgActive
          selected = angular.element @
          angular.element(@).addClass scope.kgActive