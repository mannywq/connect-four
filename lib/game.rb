require_relative './board'
require_relative './helpers'

class Game
  attr_accessor :players, :game_over, :board, :current_player

  include Helpers
  def initialize(players, board = Board.new)
    @players = players
    @game_over = false
    @board = board
    @current_player = @players[0]
    @winner = ''
  end

  def change_turn
    @current_player = @current_player == @players[0] ? @players[1] : @players[0]
  end

  def check_winner
    return false unless @board.is_winner?(@current_player.marker)

    @game_over = true

    @winner = @current_player.name

    true
  end

  def print_winner
    puts "#{@winner} wins!"
    board.print_board
  end

  def play
    loop do
      @board.print_board

      @current_player.make_move(@board)

      break if check_winner

      change_turn
    end

    print_winner
  end
end
