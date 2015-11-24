express = require 'express'
logger = require 'morgan'

app = express()

app.use logger('combined')

app.get '/', (req, res) ->
  res.send 'Storyous backend API test'

port = process.env.PORT || 5000
server = app.listen port, ->
  console.log "HTTP server is listening on port #{port}"
