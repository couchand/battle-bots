fs = require 'fs'
input = fs.readFileSync('test/test_input').toString()
input2 = fs.readFileSync('test/test_input2').toString()
input3 = fs.readFileSync('test/test_input3').toString()
input4 = fs.readFileSync('test/test_input4').toString()

deserializeState = require '../shared/deserializeState'
{move, legal, what, danger, warning} = require '../shared/helpers'
boards = require '../shared/board'

console.log input
board = deserializeState input
console.log d=danger board
console.log w=warning board
console.log boards.sum d, w

console.log input2
board = deserializeState input2
console.log d=danger board
console.log w=warning board
console.log boards.sum d, w

console.log input3
board = deserializeState input3
console.log d=danger board
console.log w=warning board
console.log boards.sum d, w

console.log input4
board = deserializeState input4
console.log d=danger board
console.log w=warning board
console.log boards.sum d, w
