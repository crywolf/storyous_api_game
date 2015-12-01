ApiController = require './api_controller'
Game = require '../models/game'

module.exports = class GamesApi extends ApiController

  create: (req, res) ->
    unless req.body.name
      res.status(422).send(); return

    game = new Game
    game.create req.body.name, (output) ->
      res.send output

  addTurn: (req, res) ->
    x = parseInt req.body.x
    y = parseInt req.body.y
    unless x and y
      res.status(422).send(); return

    Game.findById req.params.gameId, (game) ->
      if game?.isOver()
        res.status(400).send()
      else if game
        game.addTurn x, y, (output) ->
          unless output 
            res.status(400).send()
          else
            res.send output
      else
        res.status(404).send()