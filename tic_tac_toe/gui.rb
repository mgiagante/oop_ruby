module TicTacToe
  class GUI
    def self.read_player_names
      [1, 2].map do |number|
        puts "Enter a name for player #{number}"
        gets.chomp
      end
    end

    def self.read_play_for(player)
      play = nil
      until (1..9).include? play do
        puts "1|2|3"
        puts "4|5|6"
        puts "7|8|9"
        puts "#{player.name}, choose a play:" 
        play = gets.chomp.to_i
      end
      play
    end

    def self.show_board(game_board)
      puts game_board
      puts
    end

    def self.clear_screen
      Gem.win_platform? ? (system "cls") : (system "clear")
    end

    def self.announce_draw
      clear_screen
      puts "The match ended in a draw!"
    end

    def self.show_winner_for(match)
      clear_screen
      puts "The winner is #{match.winner.name} !!!"
    end
  end
end
