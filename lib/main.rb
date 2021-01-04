
require_relative '../lib/match'
require_relative '../lib/player'

round = Match.new
puts "\tXs: #{round.player1.name}\tOs: #{round.player2.name}\n\n"

loop do
  winner = false
  round.print_board
  player = 1

  until winner
    round.update_board(player)
    round.print_board
    winner = round.winner?(player)
    player = if player == 1
               2
             else
               1
             end
  end

  if round.winner == 'Tie'
    puts "It's a tie."
  else
    puts "You win, #{round.winner.name}!"
  end
  puts 'Want to play another round? (y/n)'
  again = gets.chomp.upcase

  break if again == 'N'

  round.reset_board
end
