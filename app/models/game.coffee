Model = require './model'
Point = require '../../lib/point'

module.exports = class Game extends Model

  persistance: {
    modelName: 'game'
    schema: {
      name: String,
      gameOver: Boolean,
      score: Number,
      playground: Array,
      server: Array,
      client: Array,
      created_at: Date,
      updated_at: Date
    }
  }

  beforeSave: (schema, next) ->
    currentDate = new Date()
    schema.updated_at = currentDate
    if not schema.created_at
      schema.created_at = currentDate
    next()

  create: (name, callback) ->
    playground = [
          [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
          [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
          [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
          [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
          [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
          [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
          [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
          [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
          [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
          [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
          [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
          [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
        ]

    randomIndex = _.random(1, 10)
    serverPosition = [1, randomIndex]
    playground[1][randomIndex] = 3

    randomIndex = _.random(1, 10)
    clientPosition = [playground.length - 2, randomIndex]
    playground[playground.length - 2][randomIndex] = 2

    attrs = {
      name: name,
      gameOver: false,
      score: 0,
      playground: playground,
      server: serverPosition,
      client: clientPosition
    }

    @save attrs, (record) ->
      output = {
          "gameId": record.getId(),
          "name": record.getAttribute('name'),
          "gameOver": record.getAttribute('gameOver'),
          "score": record.getAttribute('score'),
          "playground": record.getAttribute('playground')
      }
      
      callback output

  addTurn: (x, y, callback) ->
    playground = @getAttribute 'playground'

    origClientArray = @getAttribute 'client'
    origClientPosition = new Point(origClientArray[0], origClientArray[1])

    clientPosition = new Point(x, y)
#    isIllegal if @_isIllegalTurn(origClientPosition, clientPosition)

    gameOver = if @_canMakeTurn(clientPosition) then false else true

    if gameOver # client looses
      @save {gameOver: true}, (record) ->
        output = {
          "gameId": record.getId(),
          "name": record.getAttribute('name'),
          "gameOver": record.getAttribute('gameOver'),
          "score": record.getAttribute('score'),
          "playground": record.getAttribute('playground')
        }

        callback output

    else
      # client turn
      playground[origClientPosition.x][origClientPosition.y] = 0
      playground[clientPosition.x][clientPosition.y] = 2
      
      # server turn
      serverPositionArray = @getAttribute 'server'
      origServerPosition = new Point(serverPositionArray[0], serverPositionArray[1])

      serverPosition = new Point(origServerPosition.x + 1, origServerPosition.y)
      gameOver = if @_canMakeTurn(serverPosition) then false else true

      if gameOver # server looses
        @save {gameOver: true, score: @getAttribute('score') + 1}, (record) ->
          output = {
            "gameId": record.getId(),
            "name": record.getAttribute('name'),
            "gameOver": record.getAttribute('gameOver'),
            "score": record.getAttribute('score'),
            "playground": record.getAttribute('playground')
          }

          callback output
      else      
        playground[origServerPosition.x][origServerPosition.y] = 0
        playground[serverPosition.x][serverPosition.y] = 3

        attrs = {
          gameOver: gameOver,
          score: 0,
          playground: playground,
          server: serverPosition.toArray(),
          client: clientPosition.toArray()
        }

        @save attrs, (record) ->
          output = {
            "gameId": record.getId(),
            "name": record.getAttribute('name'),
            "gameOver": record.getAttribute('gameOver'),
            "score": record.getAttribute('score'),
            "playground": record.getAttribute('playground')
          }

          callback output

  isOver: ->
    @getAttribute 'gameOver'

  _canMakeTurn: (position) ->
    playground = @getAttribute 'playground'
    playground[position.x][position.y] == 0

  _isIllegalTurn: (old_pos, new_pos) ->
    #doplnit

  _timeExpired: ->
    # kontrolovat updated_at
    #
