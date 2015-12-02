Presenter = require '../presenters/presenter'

module.exports = class ScoreboardPresenter extends Presenter

  @collectionToJson: (records) ->
    data = _.map records, (record) ->
      _.pick(record, 'name', 'score')

    JSON.encode { data: data }

  @toJson: (record) ->
    JSON.encode {
      name: record.getAttribute('name'),
      score: record.getAttribute('score')
    }
