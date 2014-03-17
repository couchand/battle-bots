fs = require 'fs'

deserializeState = require '../shared/deserializeState'

input = fs.readFileSync('test_input').toString()

console.log deserializeState input
