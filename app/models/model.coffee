mongoose = require 'mongoose'

module.exports = class Model

  persistance: {
    modelName: null,
    schema: null
  }

  constructor: (attributes = {}) ->
    @_attributes = attributes
    @_configurePersistance()
    @_addBeforeSaveCallback(@beforeSave)

  getAttributes: ->
    @_attributes

  getAttribute: (name) ->
    @_attributes[name]

  getId: ->
    @getAttribute '_id'

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

    if @isPersisted() # update
      @_mongooseModel.findById @getId(), (err, foundObject) =>
        if err
          @_processError err, callback
        else
          _.extend(foundObject, attrs)
          foundObject.save (err, persistedObject) =>
            if err
              @_processError err, callback
            else
              @setAttributesFromDatabase(persistedObject)
              callback this

    else # create     
      model = new @_mongooseModel attrs

      model.save (err, persistedObject) =>
        if err
          @_processError err, callback
        else
          @setAttributesFromDatabase(persistedObject)
          callback this

  @last: (callback) ->
    record = new this()
    record._findLast callback

  _findLast: (callback) ->
    @_mongooseModel.find({}).sort({_id: -1}).limit(1).exec (err, result) =>
      if err
        @_processError err, callback
      else
        if result
          @setAttributesFromDatabase(result)
          callback this
        else
          callback null

  @findById: (id, callback) ->
    record = new this()
    record._findById id, callback

  _findById: (id, callback) ->
    @_mongooseModel.findById id, (err, result) =>
      if err
        @_processError err, callback
      else
        if result
          @setAttributesFromDatabase(result)
          callback this
        else
          callback null

  isPersisted: -> !!@getId()

  setAttributesFromDatabase: (record) ->
    if record._doc?
      what = record._doc
    else
      what = record
    _.each(what, (val, key) => 
      @_attributes[key] = val
    )
  
  _processError: (err, callback) ->
    console.error err
    callback null