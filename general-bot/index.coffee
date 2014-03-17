# all around general bot

BULLET_RATIO = 60
STRAFE_RATIO = 60
MOVE_RATIO = 30
MINE_RATIO = 10

bot = require '../shared/bot'
helpers = require '../shared/helpers'
directions = require '../shared/directions'

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

pickDir = (surroundings) ->
  dir = directions[helpers.randInt 7]
  if surroundings[dir] in ['#', 'L', 'X']
    pickDir surroundings
  else
    dir

pickMove = (board, surroundings) ->
  pref = if STRAFE_RATIO > helpers.randInt 100
    secondary board.me, board.you
  else
    primary board.me, board.you
  if surroundings[pref] in ['#', 'L', 'X']
    pickDir surroundings
  else
    pref

bot (board) ->
  surroundings = helpers.what board
  if MINE_RATIO > helpers.randInt 100
    "L #{pickDir surroundings}"
  else if MOVE_RATIO > helpers.randInt 100
    pickMove board, surroundings
  else
    shoot board.me, board.you
