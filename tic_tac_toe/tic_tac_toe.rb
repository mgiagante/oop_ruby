require './matrix'

module TicTacToe
  module Exceptions
    class CellNotFreeError < RuntimeError; end
  end

  def self.play
    match = Match.new(GUI.read_player_names)
    match.play
  end

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

  class GameBoard
    def initialize
      @matrix = Matrix.new(3, 3) do
        Cell.new
      end
    end
    
    def is_full?
      (1..3).all? do |row_number|
        (1..3).none? { |column_number| @matrix.cell(row_number, column_number).free? }
      end
    end

    # Provides 9 methods, each named after a position on the board, that return the cell in that position.
    # Example: Gameboard.new.top_left returns the top left cell of the gameboard
    def method_missing(method_name)
      positions = {
        top_left: [1, 1],
        top: [2, 1],
        top_right: [3, 1],
        left: [1, 2],
        center: [2, 2],
        right: [3, 2],
        bottom_left: [1, 3],
        bottom: [2, 3],
        bottom_right: [3, 3]
      }
      coords = positions[method_name.to_sym]
      coords ? @matrix.cell(*coords) : super
    end

    def mark_choice_for_player(number, player)
      mappings = {
        1 => :top_left,
        2 => :top,
        3 => :top_right,
        4 => :left,
        5 => :center,
        6 => :right,
        7 => :bottom_left,
        8 => :bottom,
        9 => :bottom_right
      }
      position = mappings[number]
      raise Exceptions::CellNotFreeError, "This cell is not free!" unless self.public_send(position).free?
      self.public_send(position).mark_for(player)
    end

    def to_s
      "#{top_left}|#{top}|#{top_right}\n" +
      "#{left}|#{center}|#{right}\n" +
      "#{bottom_left}|#{bottom}|#{bottom_right}\n"
    end

    def three_in_a_row?(player)
      winning_combinations = [
        [:top_left, :top, :top_right],
        [:left, :center, :right],
        [:bottom_left, :bottom, :bottom_right],
        [:top_left, :left, :bottom_left],
        [:top, :center, :bottom],
        [:top_right, :right, :bottom_right],
        [:top_left, :center, :bottom_right],
        [:top_right, :center, :bottom_left]
      ]
      winning_combinations.any? { |combination| has_all?(combination, player) }
    end

    private

    def has_all?(combination, player)
      combination.reduce(true) do |result, position|
        cell = self.public_send(position)
        result && cell.owned_by?(player)
      end
    end
  end

  class Cell
    def initialize
      @owner = nil
    end

    def free?
      !@owner
    end

    def mark_for(player)
      @owner = player
    end

    def owned_by?(player)
      @owner == player
    end

    def to_s
      free? ? " " : @owner.token
    end
  end

  class Match
    def initialize(player_names)
      @players = [Player.new(player_names.first, 'X'), Player.new(player_names.last, 'O')]
      @players.shuffle!
      @game_board = GameBoard.new
    end

    def winner
      @players.find { |player| player.has_won? }
    end

    def ended_in_a_draw?
      @game_board.is_full? && !winner
    end

    def play
      play_round until ended_in_a_draw? || winner
      winner ? GUI.show_winner_for(self) : GUI.announce_draw
    end

    def play_round
      @players.each do |player| 
        GUI.clear_screen
        GUI.show_board(@game_board)
        break if ended_in_a_draw? || winner
      begin
        choice = GUI.read_play_for(player)
        @game_board.mark_choice_for_player(choice, player)
      rescue Exceptions::CellNotFreeError => e
        puts e.message
        retry
      end
        player.mark_as_winner if @game_board.three_in_a_row?(player)
      end
    end
  end

  class Player
    attr_reader :name, :token

    def initialize(name, token)
      @name = name
      @has_won = false
      @token = token
    end

    def has_won?
      @has_won
    end

    def mark_as_winner
      @has_won = true
    end
  end
end

TicTacToe.play # Asks for the names of the players and starts the game loop. When game ends, it displays the name of the winner.
