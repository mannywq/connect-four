require_relative 'markers'

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
      return true if @grid[i][col - 1] == empty_circle
    end
    false
  end

  def full?
    @grid.each_with_index do |row, ri|
      row.each_with_index do |_col, ci|
        return false if @grid[ri][ci] == empty_circle
      end
    end
    true
  end

  def place_marker(marker, col)
    return false unless open?(col)

    (@grid.length - 1).downto(0) do |row|
      next unless @grid[row][col - 1] == empty_circle

      @grid[row][col - 1] = marker
      return true
      # puts "Marker placed at grid #{grid[row][col]}"
    end
  end

  def check_next?(pos, direction = 'x+', marker)
    y, x = pos

    return false if pos.any?(&:negative?)

    case direction
    when 'x+'
      x + 1 <= @grid[y].length && @grid[y][x + 1] == marker
    when 'y+'

      puts "Checking for #{marker}"
      y + 1 <= @grid.length - 1 && @grid[y + 1][x] == marker
    when 'y-'
      puts "Checking for #{marker}"
      (y - 1).negative? == false && @grid[y - 1][x] == marker
    when 'x-'
      (x - 1).negative? == false && @grid[y][x - 1] == marker
    end
  end

  def vert_row(col, marker)
    return false if col < 1 || col > @grid.length - 1

    length = 0
    max = 0

    (@grid.length - 1).downto(0) do |row|
      length += 1 if @grid[row][col - 1] == marker
      max = length if length > max
      length = 0 if @grid[row][col - 1] != marker
      return 4 if length == 4
    end
    [length, max].max
  end

  def hor_row(marker)
    length = 0
    max = 0

    (@grid.length - 1).downto(0) do |row|
      (0..(@grid[row].length - 1)).each do |col|
        length += 1 if @grid[row][col] == marker
        max = length if length > max
        length = 0 if @grid[row][col] != marker
        return 4 if length == 4
      end
    end
    p length
    p max
    [length, max].max
  end
end
