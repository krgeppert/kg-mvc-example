angular.module('kgapp').factory 'config', ($location)->
  loggingIsOn: ->
    $location.host()
  getBaseUrl: ->
    restHost = if _.contains( $location.host(), "ultimate-numbers.com" ) then "www.ultimate-numbers.com" else "www.ultianalytics.com"
    "http://#{restHost}/rest/view"
