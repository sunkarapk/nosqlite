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

      'exists()':
        topic: (db) ->
          db.exists this.callback

        'should be successful': (exists) ->
          assert.isTrue exists

      'existsSync()':
        topic: (db) ->
          db.existsSync()

        'should be successful': (exists) ->
          assert.isTrue exists

  .addBatch
    'Database "dummy"':
      topic: () ->
        nosqlite = require '../src/nosqlite'
        connection = new(nosqlite.Connection) path.resolve(__dirname, 'fixtures')
        connection.database 'dummy'

      'should have "dir"': (db) ->
        assert.equal db.dir, path.resolve(__dirname, 'fixtures/dummy')

      'should have "name"': (db) ->
        assert.equal db.name, 'dummy'

      'exists()':
        topic: (db) ->
          db.exists this.callback

        'should be successful': (exists) ->
          assert.isFalse exists

      'existsSync()':
        topic: (db) ->
          db.existsSync()

        'should be successful': (exists) ->
          assert.isFalse exists

  .export(module)
