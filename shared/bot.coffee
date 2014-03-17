# entry point

deserializeState = require './deserializeState'
fs = require 'fs'

data = ""
log = (msg) ->
  data += msg + "\n"

flush = ->
  #fs.appendFileSync "bot-log", data

module.exports = bot = (handle) ->

  state = process.argv[-1...][0]
  log state

  board = deserializeState state
  log JSON.stringify board, null, 2

  move = handle board
  log move
  flush()

  process.stdout.write move
