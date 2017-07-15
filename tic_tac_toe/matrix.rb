module TicTacToe
  class Matrix
    def initialize(number_of_rows, number_of_columns)
      raise ArgumentError, "Element creation block not found!" unless block_given?

      @content = (1..number_of_columns).map do
        (1..number_of_rows).map do
          yield
        end
      end
    end

    def cell(x, y)
      @content[x - 1][y - 1]
    end
  end
end
