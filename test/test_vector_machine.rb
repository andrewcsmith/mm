# require "minitest/autorun"

require "vector_machine"

class TestVectorMachine < Minitest::Test
  def setup
    @m = ::NMatrix.new([3], [0, 1, 2])
    @vm = VectorMachine.new
  end

  # Testing on 1D vectors
  def test_gets_adjacent_pairs_1d
    assert_equal N[[0, 1], [1, 2]], @vm.get_adjacent_pairs(@m)
  end
  
  # Testing on 2D vectors
  def test_gets_adjacent_pairs_2d
    @m = ::NMatrix.seq([3, 2])
    assert_equal N[[[0, 1], [2, 3]], [[2, 3], [4, 5]]], @vm.get_adjacent_pairs(@m)
  end
  
  # Testing on 3D vectors
  def test_gets_adjacent_pairs_3d
    @m = ::NMatrix.seq([3,3,2])
    exp = [
      [[[0, 1], [2, 3], [4, 5]], [[6, 7], [8, 9], [10, 11]]],
      [[[6, 7], [8, 9], [10, 11]], [[12, 13], [14, 15], [16, 17]]]
    ]
    assert_equal NMatrix.new([2,2,3,2], exp.flatten), @vm.get_adjacent_pairs(@m)
  end
  
  # Testing on the combinatorial pairs
  def test_gets_combinatorial_pairs_1d
    exp = N[[0, 1], [0, 2], [1, 2]]
    assert_equal exp, @vm.get_combinatorial_pairs(@m)
  end
  
  def test_gets_combinatorial_pairs_2d
    @m = N[[0, 1], [0, 2], [1, 2]]
    exp = N[ [[0, 1], [0, 2]], [[0, 1], [1, 2]], [[0, 2], [1, 2]] ]
    assert_equal exp, @vm.get_combinatorial_pairs(@m)
  end

  def test_old_adjacent_pairs_1d
    assert_equal N[[0, 1], [1, 2]], @vm.get_adjacent_pairs_old(@m)
  end
end


