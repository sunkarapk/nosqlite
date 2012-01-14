vows = require 'vows'
assert = require 'assert'
fs = require 'fs'
path = require 'path'

nosqlite = require '../nosqlite'
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

  .addBatch
    'Database "test"':
      topic: () ->
        connection.database 'test'

      'get()':
        topic: (db) ->
          db.get 'bob', @callback

        'should be successful': (err, data) ->
          assert.isNull err
          assert.equal data.name, 'bob'
          assert.equal data.age, 35

      'getSync()':
        topic: (db) ->
          db.getSync 'bob'

        'should be successful': (data) ->
          assert.equal data.name, 'bob'
          assert.equal data.age, 35

      'get() non-existing':
        topic: (db) ->
          db.get 'tim', @callback

        'should throw error': (err, data) ->
          assert.isUndefined data
          assert.equal err.code, 'ENOENT'

      'getSync() non-existing':
        topic: (db) ->
          db

        'should throw error': (db) ->
          assert.throws ->
            db.getSync 'tim'

  .export(module)
