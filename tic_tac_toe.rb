require 'pry'

class Match
  private
  attr_accessor :board

  public
  attr_reader :player1, :player2

  @@winner = false

  def initialize
    print "Player 1>> "
    @player1 = Player.new(1)
    print "Player 2>> "
    @player2 = Player.new(2)
    puts "\n"

    @board = [[1, 2, "X"], [4, 5, "X"], [7, 8, "X"]]
    # @board = Array.new(3) { Array.new(3) {0}}
    # for i in 0..2
    #   for j in 0..2
    #     @board[j][i] = 3 * j + i + 1
    #   end
    # end
  end

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
      player = player1
    else
      player = player2
    end
  end

  def update_board(player_number)
    player = select_player(player_number)
    move = player.make_move.to_i

    if is_move_available?(move)
      board.map! do |row|
        row.map! do |cell|
          if cell == move
            cell = player.sign
          else
            cell
          end
        end
      end
    else
      puts "\n\tCell is unavailable. Pick a different one."
    end
  end

  def check_rows(player_number, cols = @board)
    player = select_player(player_number)
    cols.reduce(false) do |win, row|
      unless win == true
        row.all?(player.sign)
      else
        win
      end
      # binding.pry
    end
  end

  def check_columns(player_number)
    flipped_board = Array.new(3) { Array.new(3) {0}}
    for i in 0..2
      for j in 0..2
        flipped_board[i][j] = board[j][i] 
      end
    end
    # binding.pry
    check_rows(player_number, flipped_board)
  end

  def check_diagonals(player_number)
    player = select_player(player_number)
    win = true
    for i in 0..2
      if board[i][i] != player.sign || board[2 - i][2 - 1] != player.sign
        win = false
      end
    end
    win
    # binding.pry
  end

  def winner(player_number)
    check_rows(player_number) || check_columns(player_number) || check_diagonals(player_number)
  end

  def reset_board
    @row1 = [1, 2, 3]
    @row2 = [4, 5, 6]
    @row3 = [7, 8, 9]
    @board = [@row1, @row2, @row3]
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
winner = false
puts "Xs: #{round.player1.name}\tOs: #{round.player2.name}"
round.print_board
puts round.winner(1)
# until winner
#   round.update_board(1)
#   round.print_board
#   round.update_board(2)
#   round.print_board
# end
