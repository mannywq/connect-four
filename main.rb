require_relative './lib/game'
require_relative './lib/player'

include Markers

player1 = Player.new(yellow_circle, 'Taro')
player2 = Player.new(blue_circle)

game = Game.new([player1, player2])

game.play
