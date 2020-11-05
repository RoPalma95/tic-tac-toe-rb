require 'pry'

class Match
  private
  attr_accessor :board, :unavailable_cells
  attr_writer :winner

  public
  attr_reader :player1, :player2, :winner

  def initialize
    print "Player 1>> "
    @player1 = Player.new(1)

    print "Player 2>> "
    @player2 = Player.new(2)
    puts "\n"

    @board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    @unavailable_cells = []
    @winner = ""
  end

  #PRIVATE METHODS

  private
  def check_rows(player_number, cols = @board)
    player = select_player(player_number)
    cols.reduce(false) do |win, row|
      unless win == true
        row.all?(player.sign)
      else
        win
      end
    end
  end

  def check_columns(player_number)
    flipped_board = Array.new(3) { Array.new(3) {0}}
    for i in 0..2
      for j in 0..2
        flipped_board[i][j] = board[j][i]
      end
    end
    check_rows(player_number, flipped_board)
  end

  def check_diagonals(player_number)
    player = select_player(player_number)
    diagonal1 = []
    diagonal2 = []
    for i in 0..2
      if board[i][i] == player.sign
        diagonal1.push(board[i][i])
      end
      if board[i][2 - i] == player.sign
        diagonal2.push(board[i][2 - i])
      end
    end
    diagonal1.length == 3 || diagonal2.length == 3
  end

  def is_move_available?(move)
    board.reduce(false) do |valid, row|
      unless valid
        row.include?(move)
      else
        valid
      end
    end
  end

  def select_player(player_number)
    if player_number == 1
      player1
    else
      player2
    end
  end

  #PUBLIC METHODS

  public
  def print_board
    puts "\n"
    board.each_with_index do |row, i|
      unless i == 2
        puts "\t     |     |"
        puts "\t  #{row[0]}  |  #{row[1]}  |  #{row[2]}"
        puts "\t_____|_____|_____"
      else
        puts "\t     |     |"
        puts "\t  #{row[0]}  |  #{row[1]}  |  #{row[2]}"
        puts "\t     |     |     "
      end
    end
    puts "\n"
  end

  def update_board(player_number)
    player = select_player(player_number)
    moved = false

    until moved
      move = player.make_move.to_i
      if is_move_available?(move)
        board.map! do |row|
          row.map! do |cell|
            if cell == move
              self.unavailable_cells.push(cell)
              cell = player.sign
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
      self.winner = "Tie"
      true
    end
  end

  def reset_board
    @board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  end
end

class Player
  attr_reader :name, :sign

  def initialize(player_number)
    @name = gets.chomp
    if player_number == 1
      @sign = "X"
    else
      @sign = "O"
    end
  end

  def make_move
    print "#{name}, input the cell you want to take>> "
    gets.chomp
  end
end

round = Match.new
puts "\tXs: #{round.player1.name}\tOs: #{round.player2.name}"

loop do
  winner = false
  round.print_board
  player = 1

  until winner
    round.update_board(player)
    round.print_board
    winner = round.winner?(player)
    if player == 1
      player = 2
    else
      player = 1
    end
  end

  unless round.winner == "Tie"
    puts "You win, #{round.winner.name}!"
  else
    puts "It's a tie."
  end
  puts "Want to play another round? (y/n)"
  again = gets.chomp.upcase

  break if again == 'N'
  round.reset_board
end
