require './matrix'

module TicTacToe
  def self.play
    match = Match.new(read_player_names)

    until match.has_a_winner? do 
      match.play_round
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
        (1..3).none? { |column_number| @matrix.cell(row_number, column_number).empty? }
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
  end

  class Cell
    def initialize
      @content = :nothing
    end

    def empty?
      @content == :nothing
    end

    def mark_for(player)
      @content = player.name.to_sym
    end
  end

  class Match
    def initialize(player_names)
      @players = player_names.map { |name| Player.new(name) }.shuffle
      @game_board = GameBoard.new
    end

    def winner
      @players.find { |player| player.has_won? }
    end

    def has_a_winner?
      !winner.nil?
    end

    def ended_in_a_draw?
      @game_board.is_full? && !has_a_winner?
    end

    def play_round
      require "pry"; binding.pry
      @players.each do |player| 
        player.play unless ended_in_a_draw? || has_a_winner?
      end
    end
  end

  class Player
    attr_reader :name

    def initialize(name)
      @name = name
      @has_won = false # TODO: Implement the condition that sets @has_won to true
    end

    def has_won?
      @has_won
    end

    def play
      # TODO: Implement playing on the game board
      require "pry"; binding.pry
    end
  end

  private

  def self.read_player_names
    [1, 2].map do |number|
      puts "Enter a name for player #{number}"
      gets.chomp
    end
  end
end

#TicTacToe.play # Asks for the names of the players and starts the game loop. When game ends, it displays the name of the winner.
