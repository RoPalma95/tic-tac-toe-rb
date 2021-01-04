
class Player
  attr_reader :name, :sign

  def initialize(player_number)
    @name = gets.chomp
    @sign = if player_number == 1
              'X'
            else
              'O'
            end
  end

  def make_move
    print "#{name}, input the cell you want to take>> "
    gets.chomp
  end
end