# angry bot

bot = require '../shared/bot'

bot ({me, you}) ->
  if me.row < you.row
    if me.col < you.col
      "SE"
    else if me.col is you.col
      "S"
    else
      "SW"
  else if me.row is you.row
    if me.col < you.col
      "E"
    else
      "W"
  else
    if me.col < you.col
      "NE"
    else if me.col is you.col
      "N"
    else
      "NW"
