global._ = require 'underscore'
express = require 'express'

require './config/application'

app = express()
require('./config/config')(app)

routes = require('./routes')(app)

port = process.env.PORT || 5000
server = app.listen port, ->
  console.log "HTTP server is listening on port #{port}"
