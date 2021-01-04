
require 'pry'

class Match
  private

  attr_accessor :board, :unavailable_cells
  attr_writer :winner

  public

  attr_reader :player1, :player2, :winner

  def initialize
    print 'Player 1>> '
    @player1 = Player.new(1)

    print 'Player 2>> '
    @player2 = Player.new(2)
    puts "\n"

    @board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    @unavailable_cells = []
    @winner = ''
  end

  # PRIVATE METHODS

  # private

  def check_rows(player_number, rows = @board)
    player = select_player(player_number)
    rows.reduce(false) do |win, row|
      if win == true
        win
      else
        row.all?(player.sign)
      end
    end
  end

  def check_columns(player_number)
    flipped_board = Array.new(3) { Array.new(3) { 0 } }
    (0..2).each do |i|
      (0..2).each do |j|
        flipped_board[i][j] = board[j][i]
      end
    end
    check_rows(player_number, flipped_board)
  end

  def check_diagonals(player_number)
    player = select_player(player_number)
    diagonal1 = []
    diagonal2 = []
    (0..2).each do |i|
      diagonal1.push(board[i][i]) if board[i][i] == player.sign
      diagonal2.push(board[i][2 - i]) if board[i][2 - i] == player.sign
    end
    diagonal1.length == 3 || diagonal2.length == 3
  end

  def move_available?(move)
    board.reduce(false) do |valid, row|
      valid || row.include?(move)
    end
  end

  def select_player(player_number)
    if player_number == 1
      player1
    else
      player2
    end
  end

  # PUBLIC METHODS

  # public

  def print_board
    board.each_with_index do |row, i|
      puts "\t     |     |"
      puts "\t  #{row[0]}  |  #{row[1]}  |  #{row[2]}"
      if i == 2
        puts "\t     |     |     "
      else
        puts "\t_____|_____|_____"
      end
    end
    puts "\n"
  end

  def update_board(player_number)
    player = select_player(player_number)
    moved = false

    until moved
      move = player.make_move.to_i
      if move_available?(move)
        board.map! do |row|
          row.map! do |cell|
            if cell == move
              unavailable_cells.push(cell)
              player.sign
            else
              cell
            end
          end
        end
        moved = true
      else
        puts "\n\tCell is unavailable. Pick a different one.\n"
      end
    end
  end

  def winner?(player_number)
    if check_rows(player_number) || check_columns(player_number) || check_diagonals(player_number)
      self.winner = select_player(player_number)
      true
    elsif unavailable_cells.length == 9
      self.winner = 'Tie'
      true
    end
  end

  def reset_board
    self.board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    unavailable_cells.clear
  end
end

