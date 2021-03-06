require './lib/player'
require './lib/computer'
require './lib/render'

class Game
  $renderer = Render.new

  def load
      $oneships = []
      $twoships = []
      #redships
      #blueships
      xs = IO.readlines('ships.csv')
      xs.each do |x|
          y = x.chomp.split(/,/)
          $oneships << Ship.new(y[0], y[1].to_i)
          $twoships << Ship.new(y[0], y[1].to_i)
      end
  end

  def continue?
    puts "\e[H\e[2J"
    puts "Press enter to continue."
    input = gets.chomp
    return false if input == '!'
    puts "\e[H\e[2J"
    return true
  end

  def setup
      load
      longship = $oneships.max {|a,b| a.length <=> b.length}
      valid = false
      puts "Welcome to battleship! Enter board size between #{longship.length} and 26"
      puts "(Enter for default of 10)."
      puts " -- (Type \'!\' at any time to exit the program.)"

      while !valid do
          print ">> "; boardsize = gets.chomp
          return false if boardsize == '!'
          if boardsize.match?(/^\d+$/)
              (boardsize.to_i < longship.length || boardsize.to_i > 26) ? \
              (puts "Board size out of bounds!") : valid = true
          elsif boardsize.match?(/^$/)
            boardsize = 10; valid = true
          else
            puts "Invalid input."
          end
      end
      boardsize = boardsize.to_i
      valid = false
      while !valid do
          puts "Enter number of players: (0, 1, or 2)."
          print ">> "; players = gets.chomp
          return false if players == '!'
          players.match?(/^[012]{1}$/) ? valid = true : \
                                  (puts "Invalid input, options are 0, 1, or 2")
      end
      $humanplayers = players.to_i
      if $humanplayers == 0
          $playerone = Computer.new("COMPUTER ONE", boardsize)
          $oneships.each {|ship| $playerone.place(ship)}
          $playertwo = Computer.new("COMPUTER TWO", boardsize)
          $twoships.each {|ship| $playertwo.place(ship)}
      elsif $humanplayers == 1
          $playerone = Player.new("   PLAYER   ", boardsize)
          puts "Place your ships."
          $oneships.each do |ship|
              puts "\e[H\e[2J"
              puts $renderer.render($playerone.board, :all)
              puts "-" * (boardsize * 6 + 11)
              result = $playerone.place(ship)
              return false if result == :quit
          end
          $playertwo = Computer.new("  COMPUTER  ", boardsize)
          $twoships.each {|ship| $playertwo.place(ship)}
      elsif $humanplayers == 2
          $playerone = Player.new(" PLAYER ONE ", boardsize)
          puts "PLAYER ONE: Place your ships."
          $oneships.each do |ship|
              puts "\e[H\e[2J"
              puts $renderer.render($playerone.board, :all)
              puts "-" * (boardsize * 6 + 11)
              result = $playerone.place(ship)
              return false if result == :quit
          end
          return false if !continue?
          $playertwo = Player.new(" PLAYER TWO ", boardsize)
          puts "\e[H\e[2J"
          puts "PLAYER TWO: Place your ships."
          $twoships.each do |ship|
              puts "\e[H\e[2J"
              puts $renderer.render($playertwo.board, :all)
              puts "-" * (boardsize * 6 + 11)
              result = $playertwo.place(ship)
              return false if result == :quit
          end
          return false if !continue?
      end
      return true
  end

  def play
      $victor = :none
      puts "\e[H\e[2J"
      if $humanplayers == 0
          while $victor == :none
              #COMPUTER ONE GO:
              result = $playerone.turn($playertwo)
              if result == :win
                  $victor = :one
                  break
              end
              input = gets.chomp
              return false if input == '!'
              puts "\e[H\e[2J"
              puts "-" * ($playerone.board.size * 6 + 11)
              #COMPUTER TWO GO:
              result = $playertwo.turn($playerone)
              if result == :win
                  $victor = :two
                  break
              end
              input = gets.chomp
              return false if input == '!'
              puts "\e[H\e[2J"
              puts "-" * ($playertwo.board.size * 6 + 11)
          end
      elsif $humanplayers == 1
          while $victor == :none
              #PLAYER ONE GO:
              puts "-" * ($playerone.board.size * 6 + 11)
              result = $playertwo.turn($playerone)
              if result == :win
                  $victor = :two
                  break
              end
              puts "-" * ($playertwo.board.size * 6 + 11)
              result = $playerone.turn($playertwo)
              return false if result == :quit
              if result == :win
                  $victor = :one
                  break
              end
              input = gets.chomp
              return false if input == '!'
              puts "\e[H\e[2J"
              puts "-" * ($playerone.board.size * 6 + 11)
              #COMPUTER GO:
              puts "PLAYER'S TURN..."
          end
      elsif $humanplayers == 2
          while $victor == :none
              #PLAYER ONE GO:
              puts "\e[H\e[2J"
              puts "PLAYER ONE'S TURN..."
              puts "-" * ($playerone.board.size * 6 + 11)
              puts $renderer.render($playerone.board, $playertwo.board, :one)
              puts "-" * ($playertwo.board.size * 6 + 11)
              result = $playerone.turn($playertwo)
              return false if result == :quit
              if result == :win
                  $victor = :one
                  break
              end
              input = gets.chomp
              return false if input == '!'
              return false if !continue?
              puts "-" * ($playerone.board.size * 6 + 11)
              #PLAYER TWO GO:
              puts "\e[H\e[2J"
              puts "PLAYER TWO'S TURN..."
              puts "-" * ($playertwo.board.size * 6 + 11)
              puts $renderer.render($playertwo.board, $playerone.board, :one)
              puts "-" * ($playertwo.board.size * 6 + 11)
              result = $playertwo.turn($playerone)
              return false if result == :quit
              if result == :win
                  $victor = :two
                  break
              end
              input = gets.chomp
              return false if input == '!'
              return false if !continue?
              puts "\e[H\e[2J"
              puts "-" * ($playertwo.board.size * 6 + 11)
          end
      end
      return true
  end
end

play_again = true

while play_again
  game = Game.new
  valid_input = false
  play_again = false
  
  if game.setup && game.play
    while !valid_input
      puts "Play again? Enter yes (y) or no (n)."
      print ">> "; user_input = gets.chomp.downcase
      if user_input.match?(/^[!ny]|yes|no$/)
        if user_input.match?(/^y|yes$/)
          play_again = true
        end
        valid_input = true
      else
        puts "Invalid input."
      end
    end
  end
end

puts "Goodbye!"
