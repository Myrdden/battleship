require './lib/cell'

class Board
    attr_reader :cells
    def initialize
        @cells = {}
        ('A'..'J').each do |x| #As in x coord of graph
            ('1'..'10').each do |y|
                @cells[(x+y).to_sym] = Cell.new
            end
        end
    end
    def valid_coordinate?(coord)
        @cells.keys.any? {|cell| cell.to_s == coord}
    end
    def
end
