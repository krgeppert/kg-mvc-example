fs = require 'fs'
_ = require 'lodash'
xmlParser = require 'xml2js'
q = require 'q'
util = require 'util'

module.exports = ()->

  readIndex().then(buildIndex).then(writeIndexToBuild)

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
    indexHtmlFile = insertScriptTags indexHtmlFile, fileNames
    jsDeferred.resolve()
    cssDeferred.promise.then ()->
      buildDeffered.resolve indexHtmlFile

  fs.readdir '/Users/kyle.geppert/Code/Personal/kg-mvc-example/build/css', (err, fileNames)->
    indexHtmlFile = insertCSSLinks indexHtmlFile, fileNames
    cssDeferred.resolve()
    jsDeferred.promise.then ()->
      buildDeffered.resolve indexHtmlFile

  buildDeffered.promise

insertScriptTags = (indexHtmlFile, fileNames)->
  scriptTags = _.reduce fileNames, (memo, fileName)->
    "#{memo}\n <script src=\"./js/#{ fileName }\"></script>"
  , ''
  console.log scriptTags
  indexHtmlFile.replace '<!-- %scripts% -->', scriptTags

insertCSSLinks = (indexHtmlFile, fileNames)->
  styleTags = _.reduce fileNames, (memo, fileName)->
    "#{memo}\n <style type=\"text/css\" src=\"./css/#{ fileName }\"></style>"
  , ''
  console.log styleTags
  indexHtmlFile.replace '<!-- %styles% -->', styleTags

writeIndexToBuild = (indexHtmlFile)->
  deferred = q.defer()
  fs.writeFile '/Users/kyle.geppert/Code/Personal/kg-mvc-example/build/index.html', indexHtmlFile,
    encoding: 'utf-8'
  , (err)->
    deferred.resolve err or true
  deferred.promise

