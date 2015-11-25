api = require '../app/api'

module.exports = (app) ->

  app.get '/', (req, res) ->
    res.send 'Storyous backend API test'

  app.post '/game', api.games.create
