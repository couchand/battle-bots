# general helpers

directions = require './directions'

direction = (a, b) ->
  if a.row < b.row
    if a.col < b.col
      "SE"
    else if a.col is b.col
      "S"
    else
      "SW"
  else if a.row is b.row
    if a.col < b.col
      "E"
    else
      "W"
  else
    if a.col < b.col
      "NE"
    else if a.col is b.col
      "N"
    else
      "NW"

clamp = (v) ->
  Math.max 0, Math.min 9, v

randInt = (max) ->
  Math.floor (1+max) * Math.random()

randOf = (choices) ->
  i = randInt choices.length
  choices[i]

move = (me, dir) ->
  row = me.row
  col = me.col
  if /N/.test dir
    row--
  if /S/.test dir
    row++
  if /W/.test dir
    col--
  if /E/.test dir
    col++
  {row, col}

legal = (pos) ->
  clamp(pos.row) is pos.row and clamp(pos.col) is pos.col

what = (board) ->
  dirs = {}
  for dir in directions
    pos = move board.me, dir
    if not legal pos
      dirs[dir] = '#'
    else
      dirs[dir] = board[pos.col][pos.row]
  dirs

distance = (a, b) ->
  dx = a.col - b.col
  dy = a.row - b.row
  Math.sqrt dx*dx + dy*dy

module.exports = {direction, distance, move, clamp, randInt, randOf, what, legal}
