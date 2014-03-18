# board magicks

board_rows = [0...10]
board_cols = [0...10]

board_map = (map) ->
  (a) ->
    ((map a[i][j] for j in board_cols) for i in board_rows)

board_pair = (join) ->
  (a, b) ->
    ((join a[i][j], b[i][j] for j in board_cols) for i in board_rows)

module.exports =
  sum: board_pair (a, b) -> a + b
  scale: (n) -> board_map (a) -> a * n
