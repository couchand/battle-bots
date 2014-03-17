# scaredy bot

bot = require '../shared/bot'
helpers = require '../shared/helpers'

bot ({me, you}) ->
  pref = helpers.direction you, me
  if /S/.test(pref) and me.row > 7 or 1 < helpers.randInt 10
    pref = helpers.randOf ['E', 'W']
  else if /N/.test(pref) and me.row < 2 or 1 < helpers.randInt 10
    pref = helpers.randOf ['E', 'W']
  else if /E/.test(pref) and me.col > 7 or 1 < helpers.randInt 10
    pref = helpers.randOf ['N', 'S']
  else if /W/.test(pref) and me.col < 2 or 1 < helpers.randInt 10
    pref = helpers.randOf ['N', 'S']
  pref
