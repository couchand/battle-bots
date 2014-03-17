fs = require 'fs'
input = fs.readFileSync('test/test_input').toString()

deserializeState = require '../shared/deserializeState'
{move, legal, what} = require '../shared/helpers'

board = deserializeState input
console.log what board
