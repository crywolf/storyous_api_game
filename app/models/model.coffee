mongoose = require 'mongoose'

module.exports = class Model

  persistance: {
    modelName: null,
    schema: null
  }

  constructor: (attributes = {}) ->
    @_configurePersistance()
    @_addBeforeSaveCallback(@beforeSave)

  _configurePersistance: ->
    if _.compact(_.values(@persistance)).length
      @modelSchema = new mongoose.Schema @persistance.schema
      # create the schema only once
      unless mongoose.models[@persistance.modelName]
        @_mongooseModel = mongoose.model @persistance.modelName, @modelSchema
      else
        @_mongooseModel = mongoose.models[@persistance.modelName] 

  _addBeforeSaveCallback: (beforeSaveCallback) ->
    if beforeSaveCallback
      @modelSchema.pre 'save', (next) ->
        beforeSaveCallback this, next

  save: (attrs, callback) ->
    throw Error('Undefined persistence schema in ' + @.constructor.modelName + ' model') unless @_mongooseModel
    model = new @_mongooseModel attrs
    model.save (err, persistedObject) ->
      if err
        console.error err
      else
        callback persistedObject

  @last: (callback) ->
    record = new this()
    record._find_last callback

  _find_last: (callback) ->
    @_mongooseModel.find({}).sort({_id: -1}).limit(1).exec (err, result) ->
      if err
        console.error err
      else
        callback result
