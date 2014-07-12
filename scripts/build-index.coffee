fs = require 'fs'
_ = require 'lodash'
xmlParser = require 'xml2js'
q = require 'q'
util = require 'util'


module.exports = (build)->
  if build is 'dev'
    readIndex().then(buildIndex).then(writeIndexToBuild)
  else
    readIndex()
      .then (indexHtmlFile)->
        indexHtmlFile = insertCSSLinks indexHtmlFile, ['main.css']
        indexHtmlFile = insertScriptTags indexHtmlFile, ['main.js']
        indexHtmlFile = replaceLiveReloadTag indexHtmlFile
        indexHtmlFile = turnOnGoogleAnalytics indexHtmlFile
        indexHtmlFile = cdnify indexHtmlFile
        writeIndexToBuild indexHtmlFile, 'dist'

readIndex = ()->

  deferred = q.defer()

  fs.readFile '/Users/kyle.geppert/Code/Personal/kg-mvc-example/app/index.html',
    encoding: 'utf-8'
  , (err, indexHtmlFile)->
    if err then deferred.reject err
    else deferred.resolve indexHtmlFile

  deferred.promise

buildIndex = (indexHtmlFile)->
  cssDeferred = q.defer()
  jsDeferred = q.defer()
  buildDeffered = q.defer()

  fs.readdir '/Users/kyle.geppert/Code/Personal/kg-mvc-example/dev/js', (err, fileNames)->
    indexHtmlFile = insertScriptTags indexHtmlFile, _.map(fileNames, (fileName)-> './js/' + fileName)
    jsDeferred.resolve()
    cssDeferred.promise.then ()->
      buildDeffered.resolve indexHtmlFile

  fs.readdir '/Users/kyle.geppert/Code/Personal/kg-mvc-example/dev/css', (err, fileNames)->
    indexHtmlFile = insertCSSLinks indexHtmlFile, _.map(fileNames, (fileName)-> './css/' + fileName)
    cssDeferred.resolve()
    jsDeferred.promise.then ()->
      buildDeffered.resolve indexHtmlFile

  buildDeffered.promise

cdnify = (indexHtmlFile)->
  indexHtmlFile = indexHtmlFile.replace /local-libraries-start -->/, ''
  indexHtmlFile = indexHtmlFile.replace /<!-- local-libraries-end/, ''
  indexHtmlFile = indexHtmlFile.replace /<!-- cdn-libraries-start/, ''
  indexHtmlFile = indexHtmlFile.replace /cdn-libraries-end -->/, ''
  indexHtmlFile

insertScriptTags = (indexHtmlFile, filePaths)->
  unless _.isArray(filePaths) then filePaths = [filePaths]
  scriptTags = _.reduce filePaths, (memo, filePath)->
    "#{memo}\n <script src=\"#{ filePath }\"></script>"
  , ''
  indexHtmlFile.replace '<!-- %scripts% -->', scriptTags

insertCSSLinks = (indexHtmlFile, filePaths)->
  unless _.isArray(filePaths) then filePaths = [filePaths]
  styleTags = _.reduce filePaths, (memo, filePath)->
    "#{memo}\n <link rel=\"stylesheet\" type=\"text/css\" href=\"#{ filePath }\"></link>"
  , ''

  indexHtmlFile.replace '<!-- %styles% -->', styleTags

replaceLiveReloadTag = (indexHtmlFile)->
  regex = /(<!-- %live-reload-start% -->).*(<!-- %live-reload-end% -->)/
  indexHtmlFile = indexHtmlFile.replace regex, ''
  indexHtmlFile

turnOnGoogleAnalytics = (indexHtmlFile)->
  regex = new RegExp "{'cookieDomain': 'none'}"
  indexHtmlFile = indexHtmlFile.replace regex, "'auto'"
  indexHtmlFile

writeIndexToBuild = (indexHtmlFile, path = 'dev')->
  deferred = q.defer()
  fs.writeFile "/Users/kyle.geppert/Code/Personal/kg-mvc-example/#{path}/index.html", indexHtmlFile,
    encoding: 'utf-8'
  , (err)->
    deferred.resolve err or true
  deferred.promise

