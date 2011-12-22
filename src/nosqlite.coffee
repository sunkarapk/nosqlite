#
# nosqlite.coffee - top level file
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

nosqlite = module.exports

# Requiring modules
path = require 'path'
fs = require 'fs'
rimraf = require 'rimraf'

# Declaring variables
nosqlite.path = path.join path.resolve(__dirname, '..'), 'data'

# Connection class for nosqlite
nosqlite.Connection = (arg) ->
  options = {}
  @path = nosqlite.path

  if typeof(arg) is 'object'
    options = arg
    @path = options.path
  else if typeof(arg) is 'string'
    @path = arg

# Database class which we work with
nosqlite.Connection::database = (name, mode) ->
  that = this
  connection = this

  # Variables
  dir: path.resolve that.path, name
  name: name || 'test'
  mode: mode || '0775'

  # Check if db exists
  exists: (cb) ->
    path.exists @dir, cb

  existsSync: ->
    path.existsSync @dir

  # Create db
  create: (cb) ->
    fs.mkdir @dir, @mode, cb

  createSync: ->
    fs.mkdirSync @dir, @mode

  # Destroy db
  destroy: (cb) ->
    rimraf @dir, cb

  destroySync: ->
    rimraf.sync @dir
