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
  end

  describe '#place_marker' do
    xit 'accepts a marker' do
    end
  end

  describe '#full?' do
    xit 'Returns true when all slots are full' do
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
        grid[i][1] = board_check.yellow_circle
      end

      board_check.print_board

      expect(board_check.open?(1)).to be false
    end
  end

  describe '#has_winner?(player)' do
    xit 'it returns true when player has secured a winning combination' do
    end
  end
end
