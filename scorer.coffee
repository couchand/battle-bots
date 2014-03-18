# scorer

BOUTS_PER_MATCH = 50
ROUNDS_PER_BOUT = 1000
DISPLAY_BOUTS = yes

directions = require './shared/directions'
{move, legal, randInt} = require './shared/helpers'

count = 0

class Bot
  constructor: (@handler) ->
    @health = 10
    @cmd = []
    @recent_bouts = 0
    @bouts = 0
    @matches = 0
  exec: (board) ->
    @handler board
  name: ->
    return @_name if @_name?
    h = @handler.toString()
    h = h[9...h.indexOf '(']
    @_name = h or count++

serialize = (board) ->
  for p in board.projectiles
    if board[p.row][p.col] is '.'
      board[p.row][p.col] = p.type
  for m in board.mines
    if board[m.row][m.col] is '.'
     board[m.row][m.col] = 'L'
  b = ((c for c in r).join ' ' for r in board).join '\n'
  b += '\n'
  b += "Y #{board.me.health}\n"
  b += "X #{board.you.health}\n"
  for p in board.projectiles
    b += "#{p.type} #{p.col} #{p.row} #{p.dir}\n"
  for m in board.mines
    b += "L #{m.col} #{m.row}\n"
  b

class Board
  constructor: (@bot1, @bot2) ->
    @board = (('.' for j in [0...10]) for i in [0...10])
    @mines = []
    @projectiles = []

    @bot1.col = 0
    @bot1.row = randInt 9
    @bot1.health = 10
    @bot2.col = 9
    @bot2.row = randInt 9
    @bot2.health = 10
  render: (bot) ->
    #console.log "rendering", this, "for", bot, @bot1, @bot2
    if bot is @bot1
      b = ((v for v in row) for row in @board)
      b[@bot1.row][@bot1.col] = 'Y'
      b[@bot2.row][@bot2.col] = 'X'
      b.me = @bot1
      b.you = @bot2
      b.mines = @mines
      b.projectiles = @projectiles
      console.log serialize b
      b
    else if bot is @bot2
      b = (v for v in row for row in @board)
      b[@bot2.row][@bot2.col] = 'Y'
      b[@bot1.row][@bot1.col] = 'X'
      b.me = @bot2
      b.you = @bot1
      b.mines = @mines
      b.projectiles = @projectiles
      b
    else
      throw new Error "unknown bot:", bot
  move_bot: (bot, dir) ->
    attempt = move bot, dir
    if legal attempt
      bot.row = attempt.row
      bot.col = attempt.col

class RoundRobin
  constructor: (handlers) ->
    @bots = (new Bot handler for handler in handlers)
    console.log "Running tournament for #{@bots.length} bots"
  run: ->
    num_matches = (n=@bots.length)*(n-1) / 2
    console.log "Running #{num_matches} matches for #{@bots.length} bots"
    match = 0
    console.log @bots
    console.log "num:", num_matches
    for i in [0...n-1]
      for j in [i+1...n]
        botI = @bots[i]
        botJ = @bots[j]
        botI.recent_bouts = 0
        botJ.recent_bouts = 0

        for bout in [0...BOUTS_PER_MATCH]
          bout = new Bout botI, botJ
          bout.run()
          console.log "match totals", botI.recent_bouts, botJ.recent_bouts

        if botI.recent_bouts > botJ.recent_bouts
          botI.matches++
        else if botJ.recent_bouts > botI.recent_bouts
          botJ.matches++

    console.log "Results:"
    for bot in @bots
      console.log "#{bot.name()}: #{bot.matches} match wins (#{bot.bouts} total bout wins)"

class Bout
  constructor: (botI, botJ) ->
    @paralyzed_turns_remaining = 0

    if randInt 1
      @bot1 = botI
      @bot2 = botJ
    else
      @bot1 = botJ
      @bot2 = botI

    @board = new Board @bot1, @bot2
    console.log "new bout between", @bot1, @bot2

  update_landmines: ->
    exploded = []
    for mine in @board.mines
      if mine.row is @bot1.row and mine.col is @bot1.col
        console.log "exploding mine at", mine.row, mine.col
        exploded.push mine
        @bot1.health -= 2
        if Math.abs(mine.row - @bot2.row) + Math.abs(mine.col - @bot2.col)
          @bot2.health -= 1
      if mine.row is @bot2.row and mine.col is @bot2.col
        exploded.push mine
        @bot2.health -= 2
        if Math.abs(mine.row - @bot1.row) + Math.abs(mine.col - @bot1.col)
          @bot1.health -= 1
    @board.mines = @board.mines.filter (m) -> m not in exploded

  update_projectiles: ->
    collided = []
    for projectile in @board.projectiles
      for j in [0...if projectile.type is 'B' then 3 else 2]
        path = move projectile, projectile.dir
        if path.row is @bot1.row and path.col is @bot1.col
          console.log "colliding #{projectile.type} at", path.row, path.col
          collided.push projectile
          if projectile.type is 'B'
            @bot1.health -= 1
          else
            @bot1.health -= 3
            if Math.abs(path.row - @bot2.row) + Math.abs(path.col - @bot2.col)
              @bot2.health -= 1
        if path.row is @bot2.row and path.col is @bot2.col
          console.log "colliding #{projectile.type} at", path.row, path.col
          collided.push projectile
          if projectile.type is 'B'
            @bot2.health -= 1
          else
            @bot2.health -= 3
            if Math.abs(path.row - @bot1.row) + Math.abs(path.col - @bot1.col)
              @bot1.health -= 1
        projectile.row = path.row
        projectile.col = path.col
    @board.projectiles = @board.projectiles.filter (p, i) ->
      p not in collided and legal p

  run: ->
    for round in [0...ROUNDS_PER_BOUT]
      bot1_cmd = @bot1.exec @board.render @bot1
      bot2_cmd = @bot2.exec @board.render @bot2

      console.log "Y #{bot1_cmd}"
      console.log "X #{bot2_cmd}"

      unless @paralyzed_turns_remaining
        moved = @move_bot @bot1, bot1_cmd
        @move_bot @bot2, bot2_cmd
        @move_bot @bot1, bot1_cmd unless moved

        @update_landmines @bot1, @bot2
        console.log "health", @bot1.health, @bot2.health
        break if @bot1.health < 1 or @bot2.health < 1
      else
        @paralyzed_turns_remaining--

      @deploy_emp @bot1, bot1_cmd
      @deploy_emp @bot2, bot2_cmd
      @fire_bullet @bot1, bot1_cmd
      @fire_bullet @bot2, bot2_cmd
      @fire_missile @bot1, bot1_cmd
      @fire_missile @bot2, bot2_cmd
      @fire_landmine @bot1, bot1_cmd
      @fire_landmine @bot2, bot2_cmd

      @update_projectiles()
      console.log "health", @bot1.health, @bot2.health
      console.log "bot2 wins" if @bot1.health < 1
      console.log "bot1 wins" if @bot2.health < 1
      break if @bot1.health < 1 or @bot2.health < 1
    # draw
    if @bot1.health > 0 and @bot1.health > @bot2.health
      @bot1.bouts++
      @bot1.recent_bouts++
    if @bot2.health > 0 and @bot2.health > @bot1.health
      @bot2.bouts++
      @bot2.recent_bouts++

  move_bot: (bot, cmd) ->
    @board.move_bot bot, cmd if cmd in directions

  deploy_emp: (bot, cmd) ->
    if cmd is 'P'
      @paralyzed_turns_remaining = 2
      bot.health--

  fire_bullet: (bot, cmd) ->
    if cmd[0] is 'B'
      @board.projectiles.push
        type: 'B'
        row: bot.row
        col: bot.col
        dir: cmd[2...]

  fire_missile: (bot, cmd) ->
    if cmd[0] is 'M'
      @board.projectiles.push
        type: 'M'
        row: bot.row
        col: bot.col
        dir: cmd[2...]

  fire_landmine: (bot, cmd) ->
    if cmd[0] is 'L'
      @board.mines.push
        row: bot.row
        col: bot.col

module.exports = RoundRobin
