fs = require 'fs'
_ = require 'lodash'
xmlParser = require 'xml2js'
q = require 'q'
util = require 'util'


module.exports = (build)->
  if build is 'dev'
    console.log 'dev mode'
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

  fs.readdir '/Users/kyle.geppert/Code/Personal/kg-mvc-example/build/js', (err, fileNames)->
    indexHtmlFile = insertScriptTags indexHtmlFile, _.each(fileNames, (fileName, index)->
      fileNames[index] = './js/' + fileName
    )
    jsDeferred.resolve()
    cssDeferred.promise.then ()->
      buildDeffered.resolve indexHtmlFile

  fs.readdir '/Users/kyle.geppert/Code/Personal/kg-mvc-example/build/css', (err, fileNames)->
    indexHtmlFile = insertCSSLinks indexHtmlFile, _.reduce(fileNames, (fileName, index)->
      fileNames[index] = './css/' + fileName
      fileNames
    )
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
  scriptTags = _.reduce filePaths, (memo, filePath)->
    "#{memo}\n <script src=\"#{ filePath }\"></script>"
  , ''
  indexHtmlFile.replace '<!-- %scripts% -->', scriptTags

insertCSSLinks = (indexHtmlFile, filePaths)->
  styleTags = _.reduce filePaths, (memo, filePath)->
    "#{memo}\n <style type=\"text/css\" src=\"#{ filePath }\"></style>"
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

writeIndexToBuild = (indexHtmlFile, path = 'build')->
  deferred = q.defer()
  fs.writeFile "/Users/kyle.geppert/Code/Personal/kg-mvc-example/#{path}/index.html", indexHtmlFile,
    encoding: 'utf-8'
  , (err)->
    deferred.resolve err or true
  deferred.promise

