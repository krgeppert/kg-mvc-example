_ = require 'lodash'
config = require './../dev-config'
utils = require 'util'

module.exports =
  scripts:
    regexes: []
    extension: '.coffee'
  styles:
    regexes: []
    extension: '.styl'
  templates:
    regexes: []
    extension: '.jade'
  images:
    regexes: []
    extension: ''

if _.contains config.inDevelopment, 'all'
  module.exports.coffee.push './app/**/*.coffee'
  module.exports.jade.push './app/**/*.jade'
  module.exports.styl.push './app/**/*.styl'
else
  _.each module.exports, (group, type)->
    _.each config.inDevelopment, (componentPath)->
      path = componentPath.split '/'
      _.reduce path, (oldPath, newPath)->
        group.regexes.push  "#{oldPath}/#{newPath}/#{type}/**/*#{group.extension}"
        "#{oldPath}/#{newPath}"
      , '.'

