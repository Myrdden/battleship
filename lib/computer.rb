require './lib/board'
require './lib/turn_result'

class Computer
  attr_reader :name, :board, :ships

  include TurnResult

  def initialize(name, size = 10)
    @name = name
    @board = Board.new(name, size)
    @ships = []
    # TO DO: ^ why needed?
  end

  def place(ship, coord_and_dir = rand_coord_and_direc)
    valid = :none

    coord, horizontal = coord_and_dir # allows for non-random placement for testing
    i = 0

    while valid != :success do
      valid = @board.place(ship, coord, horizontal)

      coord, horizontal = rand_coord_and_direc
    end

    @ships << ship
    valid
  end

  def rand_coord_and_direc
    coord = @board.cells.keys.sample
    num = rand(2)
    # 0 = right (horizontal), 1 = down (vertical)
    horizontal = num == 0
    return coord, horizontal
  end

  def find_valid_target(opp, target = random_target(opp))
    valid = false

    while !valid do
      valid = valid_target?(opp, target)
      target = random_target(opp) if !valid
      # TO DO ^ iter 4 smart computer
    end
    target
  end

  def random_target(opp)
    opp.board.cells.keys.sample
  end

  def turn(opp)
    target = find_valid_target(opp).to_sym

    puts "#{@name.lstrip.rstrip} fired on #{target}."

    return turn_result(opp, target)
  end
end
