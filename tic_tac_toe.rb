WINNING_LINES =   [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + 
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]].freeze
INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze

def prompt(msg)
  puts msg
end

# rubocop:disable Metrics/AbcSize, Style/IndentationConsistency
def display_board(brd)
  system 'clear'
    puts "You are #{PLAYER_MARKER}'s, computer is #{COMPUTER_MARKER}'s "
    puts ""
    puts "     |     |"
    puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"                               
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
    puts "     |     |"
end
# rubocop:enable Metrics/AbcSize, Style/IndentationConsistency

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }                          
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joiner(arr, delimiter, word = 'or')
  arr[-1] = "#{word} #{arr.last}" if arr.size > 1
  arr.join(delimiter)
end

def player_places_piece!(brd)
  square = ' '
  loop do                                                                          
    prompt "Choose a square: #{joiner(empty_squares(brd), ', ')}"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt 'That is not a valid option'  
  end
  brd[square] = PLAYER_MARKER
end

def find_at_risk_square(line, brd, marker)
  if brd.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 2
    brd.select{|k,v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  else
    nil
  end
end

def computer_places_piece!(brd)
  square = nil
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, PLAYER_MARKER )
    break if square
  end
  
  if !square
    WINNING_LINES.each do |line|
      square = find_at_risk_square(line, brd, COMPUTER_MARKER )
      break if square
    end
  end

  if !square
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def somebody_wins?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)  
  WINNING_LINES.each do |line|  
   
    if brd.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 3
      return 'Player Wins!'
    elsif brd.values_at(line[0], line[1], line[2]).count(COMPUTER_MARKER) == 3
      return 'Computer Wins!'
    end
  end
  nil
end

def score_keeper(results, score)
  if results == 'Player Wins!'
    score[:player] += 1
  elsif results == 'Computer Wins!'
    score[:computer] += 1  
  end
end
  
def output_score(score)
  prompt "You have #{score[:player]} point(s), and the computer has #{score[:computer]} point(s)"
  if score[:player] == 3
    prompt 'You won the best of 3 games!'
  elsif score[:computer] == 3
    prompt 'The computer won the best of 3 games!' 
  end
end

prompt 'Welcome to Ultimate Tic-Tac-Toe...'
prompt "Where it's ALL Tic-Tac-Toe, ALL the time!!!"
prompt 'Enter to continue =>...'
$stdin.gets.chomp
prompt "This ain't your Grannies Tic-Tac-Toe..."
prompt "Let's do it... Best of 3 wins! =>"
$stdin.gets.chomp 

loop do
  scores = {player: 0, computer: 0}
  until scores.value?(3)
  
  board = initialize_board
  
  loop do
    display_board(board)
    
    player_places_piece!(board)  
    break if board_full?(board) || somebody_wins?(board)  
    
    computer_places_piece!(board)
    break if board_full?(board) || somebody_wins?(board)
  end
  
  display_board(board)
  
  if somebody_wins?(board)
    prompt "#{detect_winner(board)}"
  else
    prompt "The cat gets this game.  It's a tie!"
  end
  
  score_keeper(detect_winner(board), scores)
  output_score(scores)

  prompt "Play again? Y or N:"
  play_again = gets.chomp
  break unless play_again.downcase.start_with?('y')
  end
end
  
prompt 'Thanks for playing Tic-Tac-Toe!'