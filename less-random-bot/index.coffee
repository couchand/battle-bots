# a less random bot

bot = require '../shared/bot'
{randInt, what} = require '../shared/helpers'
directions = require '../shared/directions'

pickMove = (surroundings) ->
  dir = directions[randInt 7]
  if surroundings[dir] in ['#', 'L', 'X']
    pickMove surroundings
  else
    dir

pickMine = (surroundings) ->
  dir = directions[randInt 7]
  if surroundings[dir] in ['#', 'L']
    pickMine surroundings
  else
    dir

bot (board) ->
  surroundings = what board
  switch randInt 10
    when 0, 1, 2, 3, 4, 5, 6
      pickMove surroundings
    when 7
      "B " + pickMine surroundings
    when 8
      "M " + pickMine surroundings
    else
      "L " + pickMine surroundings
