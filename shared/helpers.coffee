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

moves =
  B: 3
  M: 2

damage =
  B: 1
  M: 3

whatNext = (board) ->
  neighbors = for dir in directions
    d = move board.me, dir
    d.health = 0
    d
  for projectile in board.projectiles
    for i in [0...moves[projectile.type]]
      next = move projectile, projectile.dir
      continue unless legal next
      for neighbor in neighbors
        if neighbor.row is next.row and neighbor.col is next.col
          neighbor.health -= damage[projectile.type]
  (d.health for d in directions)

danger = (board) ->
  n = ((0 for i in [0...10]) for j in [0...10])
  for projectile in board.projectiles
    next = projectile
    for i in [0...moves[projectile.type]]
      next = move next, projectile.dir
      if projectile.type is 'M' and not legal next
        for d in directions
          schrapnel = move next, d
          if legal schrapnel
            n[schrapnel.row][schrapnel.col] += 1
      continue unless legal next
      n[next.row][next.col] += damage[projectile.type]
  for mine in board.mines
    n[mine.row][mine.col] += 2
  n

warning = (board) ->
  n = ((0 for i in [0...10]) for j in [0...10])
  for dir in directions
    p = board.you
    p = move p, dir
    continue unless legal p
    n[p.row][p.col] = damage.M - 1 # relative damage
    p = move p, dir
    continue unless legal p
    n[p.row][p.col] = damage.M
    p = move p, dir
    continue unless legal p
    n[p.row][p.col] = damage.B
  for mine in board.mines
    for dir in directions
      p = move mine, dir
      continue unless legal p
      n[p.row][p.col] += 1
  n

distance = (a, b) ->
  dx = a.col - b.col
  dy = a.row - b.row
  Math.sqrt dx*dx + dy*dy

module.exports = {direction, distance, move, clamp, randInt, randOf, what, whatNext, legal, danger, warning}
