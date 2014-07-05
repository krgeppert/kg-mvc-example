through = require 'through2'

doer = (doIt)->

  stream = through.obj (file, enc, callback)->
    doIt()
    callback()

  stream

module.exports = doer