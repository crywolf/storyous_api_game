api = require '../app/api'

module.exports = (app) ->

  app.get '/', (req, res) ->
    res.send 'Storyous backend API test'

  app.post '/game', api.games.create
  app.put '/game/:gameId', api.games.addTurn

  app.get '/scoreboard', api.scoreboard.index
  app.get '/scoreboard/:userName', api.scoreboard.score