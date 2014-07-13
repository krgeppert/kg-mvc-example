'use strict';

angular.module('kgapp', [
  'ui.router'
]).config ($stateProvider, $urlRouterProvider, $locationProvider)->

  $urlRouterProvider.otherwise "/games/kjbasd/kjnsdkjnd"

  $stateProvider
    .state 'games',
      url: "/games/{cloudId}"
      templateUrl: '/templates/games-view.html'
      controller: 'GamesCtrl'
    .state 'games.details',
      url: "/{gameId}"
      templateUrl: '/templates/game-details.html'

        # nav:
        #   templateUrl: '/templates/nav.html'
        #   controller: 'NavCtrl'
    # .state 'players',
    #   url: "/players/{cloudId}"
    #   views:
    #     nav:
    #       templateUrl: '/templates/nav.html'
    #       controller: 'NavCtrl'
    # .state 'settings',
    #   url: "/settings/{cloudId}"
    #   views:
    #     nav:
    #       templateUrl: '/templates/nav.html'
    #       controller: 'NavCtrl'
    # .state 'broadcast',
    #   url: "/broadcast/{cloudId}"
    #   views:
    #     nav:
    #       templateUrl: '/templates/nav.html'
    #       controller: 'NavCtrl'

.run ($rootScope, $state, $stateParams, logger, config)->
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams
  if config.devMode then $rootScope.console = console
  logger.info 'Welcome to the kg-mvc-example'
