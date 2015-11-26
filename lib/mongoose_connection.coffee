# Connection to MongoDB database
mongoose = require 'mongoose'
config = require '../config/environment'

mongoose.connect(config.mongo.uri, config.mongo.options);

db = mongoose.connection

db.on 'error', (err) ->
  console.error 'MongoDB connection error: ' + err
  process.exit -1

db.once 'open', (callback) ->
  console.log '-> Connected to MongoDB.'

module.exports = db