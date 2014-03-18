# state reader

deserializeBoard = (board) ->
  me = no
  you = no
  rows = board.split '\n'
  all = for i in [0...rows.length]
    row = rows[i]
    me = row: i, col: row.indexOf 'Y' if /Y/.test row
    you = row: i, col: row.indexOf 'X' if /X/.test row
    row.split ''
  throw new Error "missing player" unless me and you
  all.me = me
  all.you = you
  all

module.exports = deserializeState = (state) ->
  board = deserializeBoard state[0...110]
  rest = state[110...]
    .split '\n'
    .filter (d) -> d
  if rest[0][0] is 'Y'
    board.me.health = +rest[0][2...]
    board.you.health = +rest[1][2...]
  else
    board.you.health = +rest[0][2...]
    board.me.health = +rest[1][2...]
  board.mines = []
  board.projectiles = []
  for weapon in rest[2...]
    parts = weapon[2...].split ' '
    if weapon[0] is 'L'
      board.mines.push
        row: +parts[1]
        col: +parts[0]
    else
      board.projectiles.push
        type: weapon[0]
        row: +parts[1]
        col: +parts[0]
        dir: parts[2]
  board
