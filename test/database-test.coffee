vows = require 'vows'
assert = require 'assert'
fs = require 'fs'
path = require 'path'

vows
  .describe('database')
  .addBatch
    'Database "test"':
      topic: () ->
        nosqlite = require '../src/nosqlite'
        connection = new(nosqlite.Connection) path.resolve(__dirname, 'fixtures')
        connection.database 'test'

      'should have "dir"': (db) ->
        assert.equal db.dir, path.resolve(__dirname, 'fixtures/test')

      'should have "name"': (db) ->
        assert.equal db.name, 'test'

  .export(module)
