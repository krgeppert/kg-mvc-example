angular.module('kg-mvc').factory 'kgModel', ($rootScope, $http, $q)->
  class KgModel
    watcher = $rootScope.$new()
    url = null
    constructor: (passedUrl, watchObject)->
      url = passedUrl
      watcher.watchObject = watchObject
      @fetch()
      watcher.$watch 'watchObject', ()=>
        @fetch()
      , true
    get: ->
      @
    set: (options, replace = true)->
      if replace then _.extend @, options
      else _.each options, (val, key)=>
        unless _(@).hasKey(key) then @[key] = val
      @
    fetch: ->
      deferred = $q.defer()
      $http.get(url).then (response)=>
        _.extend @
        deferred.resolve @
      deferred.promise
    save: ->
      deferred = $q.defer()
      $http.put(url).then (response)=>
        deferred.resolve @
      deferred.promise
    clean: ->
      for attr of @
        delete @[attr]
      @