global._ = require 'underscore'

JSON.encode = (value, replace = null, space = 2) ->
  JSON.stringify(value, replace, space) + "\n"