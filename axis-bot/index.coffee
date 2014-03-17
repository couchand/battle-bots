# mounts attack on one axis

BULLET_RATIO = process.argv[2]
STRAFE_RATIO = process.argv[3]

bot = require '../shared/bot'
helpers = require '../shared/helpers'

weapon = ->
  if BULLET_RATIO > helpers.randInt 100
    "B"
  else
    "M"

primary = (me, you) ->
  dx = Math.abs me.col - you.col
  dy = Math.abs me.row - you.row
  if dx > dy
    if me.col < you.col
      'E'
    else
      'W'
  else
    if me.row < you.row
      'S'
    else
      'N'

secondary = (me, you) ->
  dx = Math.abs me.col - you.col
  dy = Math.abs me.row - you.row
  if dx > dy
    if me.row < you.row
      'S'
    else
      'N'
  else
    if me.col < you.col
      'E'
    else
      'W'

shoot = (me, you) ->
  "#{weapon()} #{primary me, you}"

strafe = (me, you) ->
  secondary me, you

bot ({me, you}) ->
  if STRAFE_RATIO > helpers.randInt 100
    strafe me, you
  else
    shoot me, you
