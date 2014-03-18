# random

{randInt} = require '../shared/helpers'
dirs = require '../shared/directions'

module.exports = ->
  switch a=randInt 10
    when 8
      "B #{dirs[randInt 7]}"
    when 9
      "M #{dirs[randInt 7]}"
    when 10
      "L #{dirs[randInt 7]}"
    else
      dirs[a]
