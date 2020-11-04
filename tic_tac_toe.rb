require 'pry'

class Match
  private
  attr_accessor :board

  public
  attr_reader :player1, :player2

  def initialize
    print "Player 1>> "
    @player1 = Player.new(1)
    print "Player 2>> "
    @player2 = Player.new(2)
    puts "\n"

    @row1 = [1, 2, 3]
    @row2 = [4, 5, 6]
    @row3 = [7, 8, 9]
    @board = [@row1, @row2, @row3]
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

  def update_board(player_number)
    if player_number == 1
      player = player1
    else
      player = player2
    end

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

until winner
  round.update_board(1)
  round.print_board
  round.update_board(2)
  round.print_board
end
