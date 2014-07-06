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
  test:
    regexes: []
    extension: '.coffee'
  css:
    regexes: []
    extension: '.css'

if _.contains config.inDevelopment, 'all'
  console.log 'TODO: Fix the "all" setting.'
  # module.exports.scripts.regexes.push './app/**/*.coffee'
  # module.exports.templates.regexes.push './app/**/*.jade'
  # module.exports.styles.regexes.push './app/**/*.styl'
else
  _.each module.exports, (group, type)->
    _.each config.inDevelopment, (componentPath)->
      path = componentPath.split '/'
      _.reduce path, (oldPath, newPath)->
        group.regexes.push  "#{oldPath}/#{newPath}/#{if type is 'css' then 'styles' else type}/**/*#{group.extension}"
        "#{oldPath}/#{newPath}"
      , '.'

