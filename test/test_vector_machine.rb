require "minitest/autorun"
require "vector_machine"

class TestVectorMachine < MiniTest::Unit::TestCase
  def setup
    @m = ::NMatrix.new([3], [0, 1, 2])
    @vm = VectorMachine.new
  end
  
  # Testing on 1D vectors
  def test_gets_adjacent_pairs_1d
    assert_equal @vm.get_adjacent_pairs(@m), N[[0, 1], [1, 2]]
  end
  
  # Testing on 2D vectors
  def test_gets_adjacent_pairs_2d
    @m = ::NMatrix.new([3, 2], [0, 1, 2, 3, 4, 5])
    assert_equal @vm.get_adjacent_pairs(@m), N[[[0, 1], [2, 3]], [[2, 3], [4, 5]]]
  end
end
