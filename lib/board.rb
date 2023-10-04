require_relative './markers'

class Board
  attr_accessor :grid

  include Markers

  def initialize
    @grid = Array.new(6) { Array.new(7) { empty_circle } }
  end

  def print_board
    @grid.each do |row|
      puts row.join(' ')
    end
    puts (1..7).to_a.join(' ')
  end

  def open?(col)
    (@grid.length - 1).downto(0) do |i|
      return true if @grid[i][col] == empty_circle
    end
    false
  end
end
