through = require 'through2'

doer = (doIt, argument)->

  stream = through.obj (file, enc, callback)->
    doIt(argument)
    callback()

  stream

module.exports = doer