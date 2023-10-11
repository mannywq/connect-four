require_relative '../lib/player'

describe Player do
  include Markers
  subject(:player) { described_class.new }
  describe '#initialize' do
    let(:p1) { described_class.new(blue_circle) }
    it 'should initialize with yellow marker as default' do
      expect(player.marker).to eq player.yellow_circle
    end
    it 'should initialize with blue marker if specified' do
      expect(p1.marker).to eq blue_circle
    end
  end

  describe '#make_move(board)' do
    let(:board) { double }
    before do
      allow(player).to receive(:prompt).and_return '2'
      allow(board).to receive(:place_marker)
    end
    it 'prompts the player for a move and calls method to place a marker on the board' do
      player.make_move(board)

      expect(player).to have_received(:prompt)
      expect(board).to have_received(:place_marker)
    end
  end
end
