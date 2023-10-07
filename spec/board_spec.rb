require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#initialize' do
    context 'Creates a 6x7 grid' do
      it 'has 6 rows' do
        expect(board.grid.length).to be 6
      end
      it 'has 7 columns on a row' do
        expect(board.grid[0].length).to be 7
      end
    end
  end

  describe '#print_board' do
    skip
  end

  describe '#place_marker' do
    subject(:board) { described_class.new }
    before do
      allow(board).to receive(:open?).and_return(true)
    end
    it 'accepts a marker' do
      grid = board.grid
      grid[0][0] = 'X'
      board.place_marker('X', 1)

      expect(grid[5][0]).to eq('X')
    end
    it 'returns false when the column is full' do
      allow(board).to receive(:open?).and_return(false)
      expect(board.place_marker('X', 1)).to be false
    end
  end

  describe '#full?' do
    it 'Returns true when all slots are full' do
      grid = board.grid
      grid.each_with_index do |row, ri|
        row.each_with_index do |_col, ci|
          grid[ri][ci] = board.yellow_circle
        end
      end
      board.print_board
      expect(board.full?).to be true
    end
  end

  describe '#open?(column)' do
    subject(:board_check) { Board.new }
    it 'Returns true when a column is open' do
      grid = board_check.grid
      grid[1][1] = board.yellow_circle

      expect(board_check.open?(1)).to be true
    end
    it 'Returns false when the column is full' do
      grid = board_check.grid

      grid.length.times do |i|
        grid[i][0] = board_check.yellow_circle
      end

      expect(board_check.open?(1)).to be false
    end
  end

  describe '#has_winner?(player)' do
    xit 'it returns true when player has secured a winning combination' do
    end
  end

  describe '#vert_row' do
    let(:row_board) { described_class.new }
    it 'Should return 1 when only 1 marker exists in column' do
      row_board.place_marker('X', 1)

      row_board.print_board
      marker = 'X'
      expect(row_board.vert_row(1, marker)).to eq 1
    end
    it 'Should return the number of markers in a row when more than 1' do
      marker = 'X'

      2.times { row_board.place_marker('X', 1) }
      row_board.print_board

      expect(row_board.vert_row(1, marker)).to eq 2
    end
    it 'Should return 4 when 4 or more markers are in a row' do
      marker = 'X'

      5.times { row_board.place_marker(marker, 1) }
      row_board.print_board
      expect(row_board.vert_row(1, marker)).to eq 4
    end
    it 'should return max consecutive values when values are mixed' do
      marker1 = 'X'
      marker2 = 'O'

      row_board.place_marker(marker1, 1)
      2.times { row_board.place_marker(marker2, 1) }
      3.times { row_board.place_marker(marker1, 1) }

      row_board.print_board

      expect(row_board.vert_row(1, marker1)).to eq 3
    end
  end

  describe '#hor_row' do
    let(:row_board) { described_class.new }

    it 'should return 1 when 1 marker is found in column' do
      marker = 'X'
      row_board.place_marker(marker, 1)
      expect(row_board.hor_row(marker)).to eq 1
    end

    it 'should return the number of markers in a row if more than 1' do
      marker = 'X'
      3.times { |num| row_board.place_marker(marker, num + 1) }
      row_board.print_board

      expect(row_board.hor_row(marker)).to eq 3
    end
    it 'should return 4 if the number of markers in a row is 4 or more' do
      marker = 'O'
      5.times { |num| row_board.place_marker(marker, num + 1) }
      row_board.place_marker('X', 6)
      row_board.place_marker('X', 7)
      row_board.print_board

      expect(row_board.hor_row(marker)).to eq 4
    end
  end

  describe '#diag_up' do
    let(:row_board) { described_class.new }
    it 'should return 1 when only 1 marker is found on a diagonal row' do
      marker = 'X'

      row_board.place_marker(marker, 1)
      row_board.print_board

      expect(row_board.diag_up(marker)).to eq 1
    end
    it 'should return 2 or number of markers when more than 1 rising' do
      marker = 'X'
      marker2 = 'O'

      row_board.place_marker(marker, 1)
      row_board.place_marker(marker2, 2)
      row_board.place_marker(marker, 2)
      2.times { row_board.place_marker(marker2, 3) }
      row_board.place_marker(marker, 3)

      row_board.print_board

      expect(row_board.diag_up(marker)).to eq 3
    end
    it 'should return 4 if the number of markers in a row is 4 or more' do
      marker = 'X'
      marker2 = 'O'

      row_board.place_marker(marker, 1)
      row_board.place_marker(marker2, 2)
      row_board.place_marker(marker, 2)
      2.times { row_board.place_marker(marker2, 3) }
      row_board.place_marker(marker, 3)
      3.times { row_board.place_marker(marker2, 4) }
      row_board.place_marker(marker, 4)

      row_board.print_board

      expect(row_board.diag_up(marker)).to eq 4
    end
    it 'should return 4 even if the sequence starts from a different column' do
      marker = 'X'
      marker2 = 'O'

      row_board.place_marker(marker, 2)
      row_board.place_marker(marker2, 3)
      row_board.place_marker(marker, 3)
      2.times { row_board.place_marker(marker2, 4) }
      row_board.place_marker(marker, 4)
      3.times { row_board.place_marker(marker2, 5) }
      row_board.place_marker(marker, 5)

      row_board.print_board

      expect(row_board.diag_up(marker, 2)).to eq 4
    end
  end

  describe '#diag_down' do
    let(:row_board) { described_class.new }
    it 'should return 1 when only 1 marker is found on a diagonal row' do
      marker = 'X'

      5.times { row_board.place_marker('O', 1) }
      row_board.place_marker(marker, 1)

      row_board.print_board
      expect(row_board.diag_down(marker)).to eq 1
    end
    it 'should return 4 when number of markers are 4 or more' do
      marker = 'X'
      marker2 = 'O'

      4.times { row_board.place_marker(marker2, 2) }
      row_board.place_marker(marker, 2)
      3.times { row_board.place_marker(marker2, 3) }
      row_board.place_marker(marker, 3)
      2.times { row_board.place_marker(marker2, 4) }
      row_board.place_marker(marker, 4)
      row_board.place_marker(marker2, 5)
      row_board.place_marker(marker, 5)
      row_board.place_marker(marker, 6)

      row_board.print_board

      expect(row_board.diag_down(marker)).to eq 4
    end
    it 'should return a number when number of markers are between 2-3' do
      marker = 'X'
      marker2 = 'O'

      4.times { row_board.place_marker(marker2, 2) }
      row_board.place_marker(marker, 2)
      3.times { row_board.place_marker(marker2, 3) }
      row_board.place_marker(marker, 3)
      2.times { row_board.place_marker(marker2, 4) }
      row_board.place_marker(marker, 4)
      2.times { row_board.place_marker(marker2, 5) }
      2.times { row_board.place_marker(marker2, 6) }

      row_board.print_board

      expect(row_board.diag_down(marker)).to eq 3
    end
  end
  describe '#diag_row' do
    let(:row_board) { described_class.new }
    it 'should return the longest number of diag matches for a marker' do
      marker = 'X'
      marker2 = 'O'

      4.times { row_board.place_marker(marker2, 2) }
      row_board.place_marker(marker, 2)
      3.times { row_board.place_marker(marker2, 3) }
      row_board.place_marker(marker, 3)
      2.times { row_board.place_marker(marker2, 4) }
      row_board.place_marker(marker, 4)
      2.times { row_board.place_marker(marker2, 5) }
      2.times { row_board.place_marker(marker2, 6) }

      row_board.print_board

      expect(row_board.diag_row(marker2)).to eq 4
    end
  end
end
