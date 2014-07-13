angular.module('kgapp').factory 'config', ($rootScope, $location)->
  if _.contains($location.host(), 'localhost') then $rootScope.console = console
  loggingIsOn: ->
    $location.host()
  getBaseUrl: ->
    restHost = if _.contains( $location.host(), "ultimate-numbers.com" ) then "www.ultimate-numbers.com" else "www.ultianalytics.com"
    "http://#{restHost}/rest/view"
  devMode: ()->
