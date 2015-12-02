GamesApi = require './api/games_api'
ScoreboardApi = require './api/scoreboard_api'

api = 
  games: new GamesApi
  scoreboard: new ScoreboardApi

module.exports = api