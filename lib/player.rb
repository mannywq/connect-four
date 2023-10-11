require_relative './markers'
require_relative './board'
require_relative './helpers'

class Player
  include Markers
  include Helpers

  attr_accessor :marker, :name

  def initialize(marker = yellow_circle, name = 'John')
    @marker = marker
    @name = name
  end

  def make_move(board)
    col = prompt("Pick your next move #{@name} (1-7): ") until col.to_i.between?(1, 7)
    board.place_marker(@marker, col)
  end
end
