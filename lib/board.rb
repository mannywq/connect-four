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

  def diag_up(marker, _start_col = 1)
    length = 0
    max = 0
    visited = []

    (@grid.length - 1).downto(0) do |row|
      (@grid[0].length - 1).downto(0) do |col|
        next unless @grid[row][col] == marker
        next if visited.include?([row, col])

        puts "Found marker at #{row}, #{col}"
        visited << [row, col]
        length = 1
        max = [length, max].max

        length = count_up([row, col], marker, visited)
        max = [length, max].max
      end
    end
    puts "Max is #{max}"
    max
  end

  def count_up(pos, marker, visited)
    row, col = pos
    row_inc = 1
    col_inc = 1
    length = 1

    while (row - row_inc).positive? && (col + col_inc) < (@grid[0].length - 1)
      @grid[row - row_inc][col + col_inc] == marker ? length += 1 : break
      visited << [(row - row_inc), (col + col_inc)]
      puts "Length is now #{length}"
      return 4 if length == 4

      row_inc += 1
      col_inc += 1

    end
    puts "Returning #{length}"
    length
  end

  def count_down(pos, marker, visited)
    row, col = pos
    inc = 1
    length = 1

    while (row + inc) <= (@grid.length - 1) && (col + inc) <= (@grid[0].length - 1)
      @grid[row + inc][col + inc] == marker ? length += 1 : break
      visited << [(row + inc), (col + inc)]
      puts "Length is now #{length}"
      return 4 if length == 4

      inc += 1

    end
    puts "Returning #{length}"
    length
  end

  def diag_down(marker)
    length = 0
    max = 0
    # inc = 1
    visited = []

    @grid.each_with_index do |row, ri|
      row.each_with_index do |_col, ci|
        next unless @grid[ri][ci] == marker

        next if visited.include?([ri, ci])

        puts "Found marker at #{ri}, #{ci}"

        visited << [ri, ci]
        length = 1

        max = [length, max].max

        length = count_down([ri, ci], marker, visited)
        max = [length, max].max
        # while (ri + inc) < (@grid.length - 1) && (ci + inc) < @grid[ri].length

        #   @grid[ri + inc][ci + inc] == marker ? length += 1 : break
        #   visited << [(ri + inc), (ci + inc)]
        #   puts "Length is now #{length}"
        #   max = [length, max].max

        #   return 4 if length == 4

        #   inc += 1

        # end
      end
    end
    max
  end

  def diag_row(marker)
    puts 'Checking rising'
    up = diag_up(marker)
    puts 'Checking falling'
    down = diag_down(marker)

    puts "Up: #{up}"
    puts "Down: #{down}"

    [up, down].max
  end
end
