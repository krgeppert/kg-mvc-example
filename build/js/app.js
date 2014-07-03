(function() {
  'use strict';
  angular.module('kg-mvc-example', ['ngRoute', 'ngCookies']).config(function($routeProvider) {
    return _.reduce({
      '/': {
        templateUrl: 'views/splash.html'
      },
      '/login/:teamId': {
        templateUrl: 'views/login.html',
        controller: 'LoginCtrl'
      },
      '/players/:teamId': {
        templateUrl: 'views/players.html',
        controller: 'PlayersCtrl'
      }
    }, function(provider, routeMapping, route) {
      return $routeProvider.when(route, routeMapping);
    }, $routeProvider).otherwise({
      redirectTo: '/'
    });
  }).run(function(auth, analytics, logging) {
    analytics.recordPageView();
    logging.info('Welcome to the kg-mvc-example');
    return auth.attempt();
  });

}).call(this);
