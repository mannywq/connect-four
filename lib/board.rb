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
    col = col.to_i
    (@grid.length - 1).downto(1) do |i|
      return true if @grid[i][(col - 1)] == empty_circle
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
    col = col.to_i
    return false unless open?(col)

    (@grid.length - 1).downto(1) do |row|
      next unless @grid[row][(col - 1)] == empty_circle

      @grid[row][col - 1] = marker
      return true
      # puts "Marker placed at grid #{grid[row][col]}"
    end
  end

  def is_winner?(marker)
    directions = []

    directions << hor_row(marker)
    directions << vert_row(marker)
    directions << diag_row(marker)

    # p directions.inspect

    directions.include?(4)
  end

  def vert_row(marker)
    length = 0
    max = 0
    visited = []

    @grid.each_with_index do |row, ri|
      row.each_with_index do |_col, ci|
        next unless @grid[ri][ci] == marker
        next if visited.include?([ri, ci])

        # puts "Found match at #{ri}, #{ci}"

        visited << [ri, ci]

        length = count_vert([ri, ci], marker, visited)
        max = [length, max].max
      end
    end
    # puts "Returning #{max}"
    max
  end

  def hor_row(marker)
    length = 0
    max = 0
    visited = []

    @grid.each_with_index do |row, ri|
      row.each_with_index do |_col, ci|
        next unless @grid[ri][ci] == marker
        next if visited.include?([ri, ci])

        visited << [ri, ci]

        length = count_horz([ri, ci], marker, visited)
        max = [length, max].max
      end
    end
    max
  end

  def diag_up(marker)
    length = 0
    max = 0
    visited = []

    @grid.each_with_index do |row, ri|
      row.each_with_index do |_col, ci|
        next unless @grid[ri][ci] == marker
        next if visited.include?([ri, ci])

        visited << [ri, ci]

        length = count_up([ri, ci], marker, visited)
        max = [length, max].max
      end
    end
    max
  end

  def diag_down(marker)
    length = 0
    max = 0
    visited = []

    @grid.each_with_index do |row, ri|
      row.each_with_index do |_col, ci|
        next unless @grid[ri][ci] == marker

        next if visited.include?([ri, ci])

        visited << [ri, ci]

        length = count_down([ri, ci], marker, visited)
        max = [length, max].max
      end
    end
    max
  end

  def diag_row(marker)
    up = diag_up(marker)
    down = diag_down(marker)

    [up, down].max
  end

  private

  def count_vert(pos, marker, visited)
    row, col = pos
    length = 1
    inc = 1

    while (row - inc) >= 0

      @grid[row - inc][col] == marker ? length += 1 : break
      visited << [(row - inc), col]
      return 4 if length == 4

      inc += 1

    end
    length
  end

  def count_horz(pos, marker, visited)
    row, col = pos
    length = 1
    inc = 1

    while (col + inc) < @grid[0].length

      @grid[row][col + inc] == marker ? length += 1 : break
      visited << [row, (col + inc)]
      return 4 if length == 4

      inc += 1

    end
    length
  end

  def count_up(pos, marker, visited)
    row, col = pos
    row_inc = 1
    col_inc = 1
    length = 1

    while (row - row_inc).positive? && (col + col_inc) < (@grid[0].length - 1)
      @grid[row - row_inc][col + col_inc] == marker ? length += 1 : break
      visited << [(row - row_inc), (col + col_inc)]
      return 4 if length == 4

      row_inc += 1
      col_inc += 1

    end
    length
  end

  def count_down(pos, marker, visited)
    row, col = pos
    inc = 1
    length = 1

    while (row + inc) <= (@grid.length - 1) && (col + inc) <= (@grid[0].length - 1)
      @grid[row + inc][col + inc] == marker ? length += 1 : break
      visited << [(row + inc), (col + inc)]
      return 4 if length == 4

      inc += 1

    end
    length
  end
end
