# require "minitest/autorun"
require "mm/pairs"

class TestMM < Minitest::Test; end

class TestMM::TestPairs < Minitest::Test
  def setup
    @pairs = MM::Pairs.new
  end

  def test_responds_to_arguments_validates_true
    assert @pairs.responds_to_arguments([], [:each, :[]])
  end

  def test_responds_to_arguments_raises_exception
    assert_raises(ArgumentError) do
      @pairs.responds_to_arguments([], [:lol])
    end
  end

  def test_get_adjacent_pairs_flat_array
    assert_equal [[0, 1], [1, 2], [2, 3]], @pairs.get_adjacent_pairs([0, 1, 2, 3])
  end

  def test_get_adjacent_pairs_nested_array
    assert_equal [[[0, 1], [2, 3]], [[2, 3], [4, 5]]], @pairs.get_adjacent_pairs([[0, 1], [2, 3], [4, 5]])
  end

  def test_get_combinatorial_pairs_flat_array
    assert_equal [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]], @pairs.get_combinatorial_pairs([0, 1, 2, 3])
  end
  
  def test_get_combinatorial_pairs_nested_array
    assert_equal [[[0, 1], [2, 3]], [[0, 1], [4, 5]], [[2, 3], [4, 5]]], @pairs.get_combinatorial_pairs([[0, 1], [2, 3], [4, 5]])
  end
end

