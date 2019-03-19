require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'

class BoardTest < Minitest::Test
  def test_it_exists
    board = Board.new

    assert_instance_of Board, board
  end

  def test_it_stores_all_cell_objects_A1_to_D4
    board = Board.new
    a1 = Cell.new('A1')
    a2 = Cell.new('A2')
    a3 = Cell.new('A3')
    a4 = Cell.new('A4')
    b1 = Cell.new('B1')
    b2 = Cell.new('B2')
    b3 = Cell.new('B3')
    b4 = Cell.new('B4')
    c1 = Cell.new('C1')
    c2 = Cell.new('C2')
    c3 = Cell.new('C3')
    c4 = Cell.new('C4')
    d1 = Cell.new('D1')
    d2 = Cell.new('D2')
    d3 = Cell.new('D3')
    d4 = Cell.new('D4')
    expected = {"A1" => a1, "A2" => a2, "A3" => a3, "A4" => a4, "B1" => b1, "B2" => b2, "B3" => b3, "B4" => b4, "C1" => c1, "C2" => c2, "C3" => c3, "C4" => c4, "D1" => d1, "D2" => d2, "D3" => d3, "D4" => d4}

    assert_equal expected, board.cells
    # to do: need to ask instructors why this is failing when it all matches!
  end

  def test_valid_coordinate_returns_true_for_good_cells
    # to do
  end

  def test_valid_coordinate_returns_false_for_bad_cells
    # to do
  end
end
