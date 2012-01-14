#
# nosqlite.coffee - top level file
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

nosqlite = module.exports

# Requiring modules
path = require 'path'
fs = require 'fs'
async = require 'async'
rimraf = require 'rimraf'

# Declaring variables
nosqlite.path = path.join __dirname, 'data'

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

  # Variables
  dir: path.resolve that.path, name
  name: name || 'test'
  mode: mode || '0775'

  # Utils
  file: (id) ->
    path.resolve @dir, id + '.json'

  project: (onto, from) ->
    Object.keys(from).forEach (k) ->
      onto[k] = from[k]
    onto

  satisy: (data, cond) ->
    Object.keys(cond).forEach (k) ->
      if data[k] isnt cond[k] then return false
    true

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

  # Get doc by id
  get: (id, cb) ->
    fs.readFile @file(id), 'utf8', (err, data) ->
      cb err, JSON.parse(data)

  getSync: (id) ->
    JSON.parse fs.readFileSync @files(id), 'utf8'

  # Remove doc by id
  delete: (id, cb) ->
    fs.unlink @file(id), cb

  deleteSync: (id) ->
    fs.unlinkSync @file(id)

  # Update doc by id
  put: (id, obj, cb) ->
    @get id, (err, data) ->
      data = @project JSON.parse(data), obj
      fs.writeFile @file(id), JSON.stringify(data), cb

  putSync: (id, obj) ->
    data = @project JSON.parse(@getSync(id)), obj
    fs.writeFileSync @file(id), JSON.stringify(data)

  # Create doc
  post: (obj, cb) ->
    fs.writeFile @file(obj.id or obj._id), JSON.stringify(obj), cb

  postSync: (obj) ->
    fs.writeFileSync @file(obj.id or obj._id), JSON.stringify(obj)

  # Find a doc
  find: (cond, cb) ->
    fs.readdir @dir, (err, files) ->
      async.map files, (file, callback) ->
        @get path.basename(file, '.json'), (err, data) ->
          if @satisfy data, cond then callback err, data else callback err, null
      , cb

  findSync: (cond) ->
    files = fs.readdirSync @dir
    files = files.map (e) ->
      data = @getSync path.basename(file, '.json')
      if @satisy data, cond then data else null
    files.filter (e) -> e?

  # Get all docs
  all: (cb) ->
    fs.readdir @dir, (err, files) ->
      async.map files, (file, callback) ->
        @get path.basename(file, '.json'), callback
      , cb

  allSync: ->
    files = fs.readdirSync @dir
    files.map (e) ->
      @getSync path.basename file, '.json'
