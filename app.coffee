global._ = require 'underscore'
express = require 'express'
logger = require 'morgan'
bodyParser = require 'body-parser'

app = express()
app.use logger('combined')
app.use bodyParser.json() # for parsing application/json
app.use bodyParser.urlencoded({ extended: true }) # for parsing application/x-www-form-urlencoded

routes = require('./routes')(app)

port = process.env.PORT || 5000
server = app.listen port, ->
  console.log "HTTP server is listening on port #{port}"
