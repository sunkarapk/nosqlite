path = require 'path'
fs = require 'fs'

nosqlite = module.exports

nosqlite.path = path.join path.resolve(__dirname, '..'), 'data'

nosqlite.Connection = (arg) ->
  options = {}
  this.path = nosqlite.path

  if typeof(arg) is 'object'
    options = arg
    this.path = options.path
  else if typeof(arg) is 'string'
    this.path = arg

nosqlite.Connection::database = (name) ->
  that = this
  connection = this

  dir = path.resolve this.dir, name

  name: name

  exists: (cb) ->
    path.exists dir, cb

  existsSync: ->
    path.existsSync dir
