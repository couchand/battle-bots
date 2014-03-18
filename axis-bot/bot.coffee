# mounts attack on one axis

helpers = require '../shared/helpers'

primary = (me, you) ->
  dx = Math.abs me.col - you.col
  dy = Math.abs me.row - you.row
  if dx > dy
    if me.col < you.col
      'E'
    else
      'W'
  else
    if me.row < you.row
      'S'
    else
      'N'

secondary = (me, you) ->
  dx = Math.abs me.col - you.col
  dy = Math.abs me.row - you.row
  if dx > dy
    if me.row < you.row
      'S'
    else
      'N'
  else
    if me.col < you.col
      'E'
    else
      'W'

module.exports = (BULLET_RATIO, STRAFE_RATIO) ->
  BULLET_RATIO ?= 60
  STRAFE_RATIO ?= 10

  weapon = ->
    if BULLET_RATIO > helpers.randInt 100
      "B"
    else
      "M"

  shoot = (me, you) ->
    "#{weapon()} #{primary me, you}"

  strafe = (me, you) ->
    secondary me, you

  ({me, you}) ->
    if STRAFE_RATIO > helpers.randInt 100
      strafe me, you
    else
      shoot me, you
