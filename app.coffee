require './config/application'
require './lib/mongoose_connection'
config = require './config/environment'
express = require 'express'

app = express()
require('./config/express')(app)
require('./config/routes')(app)

port = config.port
server = app.listen port, ->
  console.log "-> HTTP server is listening on port #{port}."
