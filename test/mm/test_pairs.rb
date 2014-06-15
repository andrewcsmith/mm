# require "minitest/autorun"
require "mm/pairs"

class TestMM < Minitest::Test; end

class TestMM::TestPairs < Minitest::Test
  def setup
    @pairs = MM::Pairs.new
  end

  def test_linear_flat_array
    assert_equal [[0, 1], [1, 2], [2, 3]], @pairs.linear([0, 1, 2, 3])
  end

  def test_linear_nested_array
    assert_equal [[[0, 1], [2, 3]], [[2, 3], [4, 5]]], @pairs.linear([[0, 1], [2, 3], [4, 5]])
  end

  def test_combinatorial_flat_array
    assert_equal [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]], @pairs.combinatorial([0, 1, 2, 3])
  end
  
  def test_combinatorial_nested_array
    assert_equal [[[0, 1], [2, 3]], [[0, 1], [4, 5]], [[2, 3], [4, 5]]], @pairs.combinatorial([[0, 1], [2, 3], [4, 5]])
  end
end

