# agressive mining bot

MINE_RATIO = 30

bot = require '../shared/bot'
helpers = require '../shared/helpers'
directions = require '../shared/directions'

pickDir = (surroundings) ->
  dir = directions[helpers.randInt 7]
  if surroundings[dir] in ['#', 'L', 'X']
    pickDir surroundings
  else
    dir

bot (board) ->
  {me, you} = board
  surroundings = helpers.what board
  if MINE_RATIO > helpers.randInt 100
    "L #{pickDir surroundings}"
  else
    pickDir surroundings
