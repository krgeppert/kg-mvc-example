'use strict';

angular.module('kgapp', [
  'ui.router'
  # 'kg-utilities'
]).config ($stateProvider, $urlRouterProvider, $locationProvider)->

  $urlRouterProvider.otherwise "/games"

  $stateProvider
    .state 'games',
      url: "/games"
      views:
        nav:
          templateUrl: '/templates/nav.html'
          controller: 'NavCtrl'

.run (logger)->
  logger.info 'Welcome to the kg-mvc-example'