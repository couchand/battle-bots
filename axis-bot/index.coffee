# mounts attack on one axis

BULLET_RATIO = process.argv[2]
STRAFE_RATIO = process.argv[3]

bot = require '../shared/bot'
axis_bot = require './bot'

bot axis_bot BULLET_RATIO, STRAFE_RATIO
