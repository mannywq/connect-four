require_relative '../lib/game'
require_relative '../lib/markers'

describe Game do
  include Markers
  let(:player1) { double }
  let(:player2) { double }
  let(:board) { double }

  subject(:game) { described_class.new([player1, player2], board) }
  describe '#initialize' do
    it 'initializes with 2 players' do
      expect(game.players.length).to be 2
    end
  end
  describe '#change_turn' do
    it 'Changes the turn to the other player' do
      game.current_player = game.players[0]

      game.change_turn

      expect(game.current_player).to eq game.players[1]
    end
  end

  describe '#check_winner' do
    before do
      allow(board).to receive(:is_winner?).and_return(true)
      allow(game.current_player).to receive(:marker).and_return(yellow_circle)
    end

    it 'Sets game over to true when a winner is found' do
      game.check_winner

      expect(game.game_over).to be true
    end
  end

  describe '#print_winner' do
    it 'Prints the name of the winner' do
      expect(game).to receive(:puts)
      game.print_winner
    end
  end

  describe '#play' do
    before do
      allow(game.board).to receive(:print_board)
      allow(player1).to receive(:make_move)
      allow(player2).to receive(:make_move)
      allow(game.board).to receive(:is_winner?).and_return(true)
      allow(game).to receive(:check_winner).and_return(false, true)
    end

    it 'Prints the game board' do
      puts 'Printing the board'
      expect(game.board).to receive(:print_board)
      game.play
    end

    it 'Prompts the player for a move' do
      puts 'Making a move'
      expect(player1).to receive(:make_move)
      game.play
    end

    it 'Checks for a winner' do
      puts 'Checking for a winner'
      expect(game).to receive(:check_winner)
      game.play
    end

    it 'Changes turns' do
      puts 'Changing turns'
      game.play

      expect(game.current_player).to eq player2
    end

    it 'Breaks when game over is true' do
      allow(game).to receive(:check_winner).and_call_original
      allow(game.current_player).to receive(:marker).and_return(yellow_circle)
      puts 'Breaking when game over is true'

      expect(game).to receive(:print_winner)
      game.play
    end
  end
end
