module.exports = class Point
  constructor: (x, y) ->
    @x = x or 0
    @y = y or 0

  toArray: ->
    [@x, @y]