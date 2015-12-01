Presenter = require '../presenters/presenter'

module.exports = class GamePresenter extends Presenter

  @toJson: (game) ->
    JSON.encode {
      gameId: game.getId(),
      name: game.getAttribute('name'),
      gameOver: game.getAttribute('gameOver'),
      score: game.getAttribute('score'),
      playground: game.getAttribute('playground')
    }, null, ''
