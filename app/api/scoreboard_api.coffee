ApiController = require './api_controller'
Scoreboard = require '../models/scoreboard'
ScoreboardPresenter = require '../presenters/scoreboard_presenter'

module.exports = class ScoreboardApi extends ApiController

  index: (req, res) ->
    scoreboard = new Scoreboard
    scoreboard.getAllScores (scores) ->
      res.send ScoreboardPresenter.collectionToJson(scores)

  score: (req, res) ->
    scoreboard = new Scoreboard
    scoreboard.getScore req.params.userName, (score) ->
      if score
        res.send ScoreboardPresenter.toJson(score)
      else
        res.status(404).send()