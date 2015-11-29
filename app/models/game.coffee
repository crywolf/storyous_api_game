Model = require './model'

module.exports = class Game extends Model

  persistance: {
    modelName: 'game'
    schema: {
      name: String,
      gameOver: Boolean,
      score: Number,
      playground: Array,
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

  create: (name, done) ->
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

    randomIndex = _.random(1, 11)
    playground[1][randomIndex] = 3

    randomIndex = _.random(1, 11)
    playground[playground.length - 2][randomIndex] = 2

    attrs = {
      name: name,
      gameOver: false,
      score: 0,
      playground: playground
    }

    @save attrs, (record) ->
      output = {
        "gameId": record._id,
        "name": name,
        "gameOver": false,
        "score": 0,
        "playground": playground
        }
      
      done output