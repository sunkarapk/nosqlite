vows = require 'vows'
assert = require 'assert'
fs = require 'fs'
path = require 'path'

nosqlite = require '../src/nosqlite'
connection = new(nosqlite.Connection) path.resolve(__dirname, 'fixtures')

vows
  .describe('database')
  .addBatch
    'Database "test"':
      topic: () ->
        connection.database 'test'

      'should have "dir"': (db) ->
        assert.equal db.dir, path.resolve(__dirname, 'fixtures/test')

      'should have "name"': (db) ->
        assert.equal db.name, 'test'

      'exists()':
        topic: (db) ->
          db.exists @callback

        'should be successful': (exists) ->
          assert.isTrue exists

      'existsSync()':
        topic: (db) ->
          db.existsSync()

        'should be successful': (exists) ->
          assert.isTrue exists

      'create()':
        topic: (db) ->
          db

        'should throw error': (db) ->
          assert.throws db.create()

  .addBatch
    'Database "dummy"':
      topic: () ->
        connection.database 'dummy'

      'should have "dir"': (db) ->
        assert.equal db.dir, path.resolve(__dirname, 'fixtures/dummy')

      'should have "name"': (db) ->
        assert.equal db.name, 'dummy'

      'exists()':
        topic: (db) ->
          db.exists @callback

        'should be successful': (exists) ->
          assert.isFalse exists

      'existsSync()':
        topic: (db) ->
          db.existsSync()

        'should be successful': (exists) ->
          assert.isFalse exists

  .addBatch
    'Database "dummy"':
      topic: () ->
        connection.database 'dummy'

      'create()':
        topic: (db) ->
          db.create @callback

        'should be successful': (ex) ->
          assert.isUndefined ex
          assert.isTrue path.existsSync(path.resolve(__dirname, 'fixtures/dummy'))

  .addBatch
    'Database "dummy"':
      topic: () ->
        connection.database 'dummy'

      'destroy()':
        topic: (db) ->
          db.destroy @callback

        'should be successful': (ex) ->
          assert.isUndefined ex
          assert.isFalse path.existsSync(path.resolve(__dirname, 'fixtures/dummy'))

  .addBatch
    'Database "dummy"':
      topic: () ->
        connection.database 'dummy'

      'createSync()':
        topic: (db) ->
          db

        'should be successful': (db) ->
          assert.isUndefined db.createSync()
          assert.isTrue path.existsSync(path.resolve(__dirname, 'fixtures/dummy'))

  .addBatch
    'Database "dummy"':
      topic: () ->
        connection.database 'dummy'

      'destroySync()':
        topic: (db) ->
          db

        'should be successful': (db) ->
          assert.isUndefined db.destroySync()
          assert.isFalse path.existsSync(path.resolve(__dirname, 'fixtures/dummy'))


  .export(module)
