# huggy bot, in js

bot = require '../shared/bot'
helpers = require '../shared/helpers'

bot ({me, you}) ->
  helpers.direction me, you
