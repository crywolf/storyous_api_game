config = require './environment'
logger = require 'morgan'
bodyParser = require 'body-parser'

module.exports = (app) ->
  
  app.use logger('combined')
  app.use bodyParser.json() # for parsing application/json
  app.use bodyParser.urlencoded({ extended: true }) # for parsing application/x-www-form-urlencoded

  forceSsl = (req, res, next) ->
    if req.headers['x-forwarded-proto'] != 'https' and config.env == 'production'
      res.redirect 307, "https://#{req.header 'host'}#{req.url}"
    else
      next()

  app.use forceSsl
