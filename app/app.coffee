'use strict';

angular.module('kg-mvc-example', [
  'ngRoute'
  'ngCookies'
]).config(($routeProvider)->
  _.reduce(
    '/':
      templateUrl: 'views/splash.html'
    '/login/:teamId':
      templateUrl: 'views/login.html'
      controller: 'LoginCtrl'
    '/players/:teamId':
      templateUrl: 'views/players.html'
      controller: 'PlayersCtrl'
  , (provider, routeMapping, route)->
    $routeProvider.when route, routeMapping
  , $routeProvider
  ).otherwise
    redirectTo: '/'
).run (auth, analytics, logging)->

  analytics.recordPageView()

  logging.info 'Welcome to the kg-mvc-example'

  auth.attempt()
