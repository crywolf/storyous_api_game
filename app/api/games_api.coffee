ApiController = require './api_controller'
Game = require '../models/game'

module.exports = class GamesApi extends ApiController

  create:  (req, res) ->
    unless req.body.name
      res.status(422).send(); return

    game = new Game
    output = game.create(req.body.name)
    res.send output
