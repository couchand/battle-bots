# shooty bot

BULLET_RATIO = 60

bot = require '../shared/bot'
helpers = require '../shared/helpers'

weapon = ->
  if BULLET_RATIO < helpers.randInt 100
    "B"
  else
    "M"

bot ({me, you}) ->
  "#{weapon()} #{helpers.direction me, you}"
