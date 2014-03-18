# i know kung fu

{direction, distance, move, legal, danger, warning, randInt, randOf} = require '../shared/helpers'
boards = require '../shared/board'
directions = require '../shared/directions'

chooseSafeDir = ({me, you}, lava) ->
  dirs = []
  min = +Infinity
  for dir in directions
    guess = move me, dir
    continue unless legal guess
    guess.dir = dir
    guess.damage = lava[guess.row][guess.col]
    min = guess.damage if guess.damage < min
    dirs.push guess
  dirs.sort (a, b) ->
    if a.damage < b.damage
      -1
    else if b.damage < a.damage
      1
    else
      0
  choice = randOf dirs.filter (d) ->
    d.damage < min + 1
  choice = choice or dirs[0]
  choice.dir

module.exports = (WARNING_FACTOR, MISSILE_FACTOR, MOVE_FACTOR) ->
  WARNING_FACTOR ?= 0.6
  MISSILE_FACTOR ?= 0.8
  MOVE_FACTOR ?= 0.4

  combine = (d, w) ->
    boards.sum d, boards.scale(WARNING_FACTOR)(w)

  shoot = ({me, you}) ->
    weapon = if Math.random() < MISSILE_FACTOR then 'M' else 'B'
    dir = direction me, you
    "#{weapon} #{dir}"

  (board) ->
    lava = combine danger(board), warning(board)

    if lava[board.me.row][board.me.col] or Math.random() < MOVE_FACTOR
      chooseSafeDir board, lava
    else
      shoot board
