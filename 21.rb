SUITS = ['Heart', 'Diamonds', 'Spades', 'Clubs'].freeze
CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].freeze

def shuffle_deck
  CARDS.product(SUITS).shuffle
end

def value(cards)
  
  totals = cards.map { |card| card[0] }
  
  sum = 0
  totals.each do |values|
    if values == 'A'
      sum += 11
    elsif values.to_i == 0
      sum += 10
    else
      sum += values.to_i
    end
  end
  
  totals.count { |value| value == 'A' }.times do
    sum -= 10 if sum > 21
  end
  
  sum
end

def bust?(cards)
  value(cards) > 21
end

def results(dealer_cards, player_cards)
  players_value = value(player_cards)
  dealers_value = value(dealer_cards)
  
  if players_value > 21
    :player_busted
  elsif dealers_value > 21
    :dealer_busted  
  elsif players_value > dealers_value
    :player_win
  elsif dealers_value > players_value
    :dealer_win
  else
    :tie
  end
end
   
def show_results(dealer_cards, player_cards)   
  display = results(dealer_cards, player_cards)
  
  case display
  when :player_busted
    puts 'Busted! The house wins!'
  when :dealer_busted
    puts 'Dealer busted! You win!'
  when :player_win
    puts 'You win!'
  when :dealer_win
    puts 'Dealer wins!'
  when :tie
    puts "Womp, womp... it's a tie."
  end
end

def play_again?
  puts "Play again? 'y' or 'n':"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

loop do
  system "clear"
  puts "Let's play BLACKJACK"
  puts "Enter to continue =>"
  $stdin.gets.chomp
  
  deck = shuffle_deck
  player_cards = []
  dealer_cards = []
  
  2.times do 
    player_cards << deck.shift
    dealer_cards << deck.shift
  end
  
  puts "Dealers hand: #{dealer_cards[0]} & ???"
  puts
  puts "Your hand: #{player_cards[0]} & #{player_cards[1]} for #{value(player_cards)}."
  
  
    
  loop do
  
    player_turn = nil
    loop do
      puts "Player, (h)it or (s)tay:"
      player_turn = gets.chomp.downcase
      break if ['h', 's'].include?(player_turn)
    end
    
    if player_turn == 'h'
      player_cards << deck.shift
      puts "Player hits... Players hand is now: \n#{player_cards} for a value of #{value(player_cards)}"
    end
    
    break if player_turn == 's' || bust?(player_cards)
  end
  
  if bust?(player_cards)
    show_results(dealer_cards, player_cards)
    play_again? ? next : break
  else
    puts "You stay at #{value(player_cards)}"
    puts "=>"
    $stdin.gets.chomp
  end
  
  puts "Dealers turn:"
  
  loop do 
     
    puts "Dealer shows second card"
    puts
    puts "#{dealer_cards}"
  
    break if bust?(dealer_cards) || value(dealer_cards) >= 17
    
    puts "Dealer hits...=>"
    $stdin.gets.chomp
    dealer_cards << deck.shift
    
    puts "Dealers hand is now: \n#{dealer_cards}"
    puts
  end
  
  if bust?(dealer_cards)
    puts "Dealers total: #{value(dealer_cards)}"
    show_results(dealer_cards, player_cards)
    play_again? ? next : break
  else
    puts "Dealer stays at #{value(dealer_cards)}"
  end
  
  puts "******************************************"
  system 'clear'
  puts "Dealer has #{dealer_cards}, with a value of #{value(dealer_cards)}..."
  puts "You have #{player_cards}, with a value of #{value(player_cards)}."
  puts
  show_results(dealer_cards, player_cards)
  puts "******************************************"
  
  play_again? ? next : break
end

puts "Thanks for trying your luck at BLACKJACK!!!"
