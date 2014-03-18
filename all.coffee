# test all

RoundRobin = require './scorer'

random = require './random-bot/bot'
axis = require './axis-bot/bot'
neo = require './neo-bot/bot'

tournament = new RoundRobin [
  random, axis(), neo()
]

tournament.run()
