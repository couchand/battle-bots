# i know kung fu

WARNING_FACTOR = +process.argv[2]
MISSILE_FACTOR = +process.argv[3]
MOVE_FACTOR = +process.argv[4]

bot = require '../shared/bot'
neo_bot = require './bot'

bot neo_bot WARNING_FACTOR, MISSILE_FACTOR, MOVE_FACTOR
