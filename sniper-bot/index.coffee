# sniper bot

BULLET_RATIO = 60
STRAFE_RATIO = 10

bot = require '../shared/bot'
helpers = require '../shared/helpers'

weapon = ->
  if BULLET_RATIO > helpers.randInt 100
    "B"
  else
    "M"

shoot = (me, you) ->
  "#{weapon()} #{helpers.direction me, you}"

strafe = (me, you) ->
  dx = Math.abs me.col - you.col
  dy = Math.abs me.row - you.row
  if dx > dy
    if me.row < you.row
      'S'
    else if me.row > you.row or helpers.randInt 1
      'N'
    else
      'S'
  else
    if me.col < you.col
      'E'
    else if me.col > you.col or helpers.randInt 1
      'W'
    else
      'E'

moveAway = (me, you) ->
  pref = helpers.direction you, me
  if /S/.test(pref) and me.row > 7
    pref = strafe me, you
  else if /N/.test(pref) and me.row < 2
    pref = strafe me, you
  if /E/.test(pref) and me.col > 7
    pref = strafe me, you
  else if /W/.test(pref) and me.col < 2
    pref = strafe me, you
  pref

bot ({me, you}) ->
  if 3 < helpers.distance me, you
    if STRAFE_RATIO > helpers.randInt 100
      strafe me, you
    else
      shoot me, you
  else
    if STRAFE_RATIO > helpers.randInt 100
      moveAway me, you
    else
      shoot me, you
