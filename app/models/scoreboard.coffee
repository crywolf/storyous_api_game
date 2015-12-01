Model = require './model'
Point = require '../../lib/point'

module.exports = class Scoreboard extends Model

  persistance: {
    modelName: 'scoreboard'
    schema: {
      name: { type: String, required: true, unique: true },
      score: Number
    }
  }

  addScore: (callback) ->
    userName = @getAttribute 'name'

    query = {name: userName}
    console.log query

    options = { new: true, upsert: true }
    @_mongooseModel.findOneAndUpdate query, { name: userName, $inc: { score: 1 }}, options, (err, record) =>
      if err
        @_processError err, callback
      else
        @setAttributesFromDatabase(record)
        callback this    
