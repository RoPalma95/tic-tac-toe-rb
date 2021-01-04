
require_relative '../lib/match'
require_relative '../lib/player'

describe Match do

  describe '#winner?' do

    let(:player1) { instance_double(Player, name: 'Rodri', sign: 'X') }
    let(:player2) { instance_double(Player, name: 'Mick', sign: 'O') }
    subject(:match) { described_class.new }

    before do
      match.instance_variable_set(:@player1, player1)
      match.instance_variable_set(:@player2, player2)
    end

    context "on player 1's turn, all Xs in a row" do
      it 'player 1 is winner' do
        current_player = 1
        allow(match).to receive(:check_rows).with(current_player).and_return(true)
        match.winner?(current_player)
        expect(match.winner).to eq(player1)
      end
    end

    context "on player 1's turn, all Xs in a column" do
      it 'player 1 is winner' do
        current_player = 1
        allow(match).to receive(:check_columns).with(current_player).and_return(true)
        match.winner?(current_player)
        expect(match.winner).to eq(player1)
      end
    end

    context "on player 1's turn, all Xs in a diagonal" do
      it 'player 1 is winner' do
        current_player = 1
        allow(match).to receive(:check_rows).with(current_player).and_return(true)
        match.winner?(current_player)
        expect(match.winner).to eq(player1)
      end
    end

    context "on player 2's turn, all Os in a row" do
      it 'player 2 is winner' do
        current_player = 2
        allow(match).to receive(:check_rows).with(current_player).and_return(true)
        match.winner?(current_player)
        expect(match.winner).to eq(player2)
      end
    end

    context "on player 2's turn, all Os in a column" do
      it 'player 2 is winner' do
        current_player = 2
        allow(match).to receive(:check_columns).with(current_player).and_return(true)
        match.winner?(current_player)
        expect(match.winner).to eq(player2)
      end
    end

    context "on player 2's turn, all Os in a diagonal" do
      it 'player 2 is winner' do
        current_player = 2
        allow(match).to receive(:check_diagonals).with(current_player).and_return(true)
        match.winner?(current_player)
        expect(match.winner).to eq(player2)
      end
    end

    context "no more spaces available for another move" do

      before do
        match.instance_variable_set(:@unavailable_cells, Array.new(9))
      end

      it 'match is a tie' do
        current_player = 1
        match.winner?(current_player)
        expect(match.winner).to eq('Tie')
      end
    end
  end

  describe '#check_rows' do

    let(:player1) { instance_double(Player, name: 'Rodri', sign: 'X') }
    let(:player2) { instance_double(Player, name: 'Mick', sign: 'O') }
    subject(:match) { described_class.new }

    before do
      match.instance_variable_set(:@player1, player1)
      match.instance_variable_set(:@player2, player2)
    end

    context "on player 1's turn, first row is all Xs" do
      before do
        first_row = [['X', 'X', 'X'], [0, 0, 0], [0, 0, 0]]
        match.instance_variable_set(:@board, first_row)
      end

      it "returns true" do
        current_player = 1
        check = match.check_rows(current_player)
        expect(check).to be true
      end
    end

    context "on player 1's turn, second row is all Xs" do
      before do
        second_row = [[0, 0, 0], ['X', 'X', 'X'], [0, 0, 0]]
        match.instance_variable_set(:@board, second_row)
      end

      it "returns true" do
        current_player = 1
        check = match.check_rows(current_player)
        expect(check).to be true
      end
    end

    context "on player 1's turn, third row is all Xs" do
      before do
        third_row = [[0, 0, 0], [0, 0, 0], ['X', 'X', 'X']]
        match.instance_variable_set(:@board, third_row)
      end

      it "returns true" do
        current_player = 1
        check = match.check_rows(current_player)
        expect(check).to be true
      end
    end

    context "on player 2's turn, first row is all Os" do
      before do
        first_row = [['O', 'O', 'O'], [0, 0, 0], [0, 0, 0]]
        match.instance_variable_set(:@board, first_row)
      end

      it "returns true" do
        current_player = 2
        check = match.check_rows(current_player)
        expect(check).to be true
      end
    end

    context "on player 2's turn, second row is all Os" do
      before do
        second_row = [[0, 0, 0], ['O', 'O', 'O'], [0, 0, 0]]
        match.instance_variable_set(:@board, second_row)
      end

      it "returns true" do
        current_player = 2
        check = match.check_rows(current_player)
        expect(check).to be true
      end
    end

    context "on player 2's turn, third row is all Os" do
      before do
        third_row = [[0, 0, 0], [0, 0, 0], ['O', 'O', 'O']]
        match.instance_variable_set(:@board, third_row)
      end

      it "returns true" do
        current_player = 2
        check = match.check_rows(current_player)
        expect(check).to be true
      end
    end
  end

  describe '#check_columns' do

    let(:player1) { instance_double(Player, name: 'Rodri', sign: 'X') }
    let(:player2) { instance_double(Player, name: 'Mick', sign: 'O') }
    subject(:match) { described_class.new }

    before do
      match.instance_variable_set(:@player1, player1)
      match.instance_variable_set(:@player2, player2)
    end

    context 'rows and columns are flipped' do
      it 'sends flipped board to #check_rows' do
        player = 1
        flipped_board = [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
        expect(match).to receive(:check_rows).with(player, flipped_board)
        match.check_columns(player)
      end
    end
  end

  describe '#check_diagonals' do

    let(:player1) { instance_double(Player, name: 'Rodri', sign: 'X') }
    let(:player2) { instance_double(Player, name: 'Mick', sign: 'O') }
    subject(:match) { described_class.new }

    before do
      match.instance_variable_set(:@player1, player1)
      match.instance_variable_set(:@player2, player2)
    end

    context "on player 1's turn, all Xs left-right diagonal" do
      before do
        lr_diagonal = [['X', 2, 3], [4, 'X', 6], [7, 8, 'X']]
        match.instance_variable_set(:@board, lr_diagonal)
      end

      it 'returns true' do
        current_player = 1
        check = match.check_diagonals(current_player)
        expect(check).to be true
      end
    end

    context "on player 1's turn, all Xs right-left diagonal" do
      before do
        rl_diagonal = [[1, 2, 'X'], [4, 'X', 6], ['X', 8, 9]]
        match.instance_variable_set(:@board, rl_diagonal)
      end

      it 'returns true' do
        current_player = 1
        check = match.check_diagonals(current_player)
        expect(check).to be true
      end
    end

    context "on player 2's turn, all Os left-right diagonal" do
      before do
        lr_diagonal = [['O', 2, 3], [4, 'O', 6], [7, 8, 'O']]
        match.instance_variable_set(:@board, lr_diagonal)
      end

      it 'returns true' do
        current_player = 2
        check = match.check_diagonals(current_player)
        expect(check).to be true
      end
    end

    context "on player 2's turn, all Os right-left diagonal" do
      before do
        rl_diagonal = [[1, 2, 'O'], [4, 'O', 6], ['O', 8, 9]]
        match.instance_variable_set(:@board, rl_diagonal)
      end

      it 'returns true' do
        current_player = 2
        check = match.check_diagonals(current_player)
        expect(check).to be true
      end
    end
  end
end