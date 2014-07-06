'use strict';

angular.module('kgapp', [
  'ngRoute'
]).config ($routeProvider, $locationProvider)->

  $routeProvider.when '/',
    templateUrl: 'templates/splash.html'
    controller: 'SplashCtrl'
  .otherwise
    redirectTo: '/'

  $locationProvider.html5Mode true

.run (logger)->
  logger.info 'Welcome to the kg-mvc-example'
