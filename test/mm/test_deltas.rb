require 'mm/deltas'

class TestMM < Minitest::Test; end

class TestMM::TestDeltas < Minitest::Test
  def test_abs_ordered_inter_delta
    input = [[5, 12], [4, 2], [3, 11], [6, 7]]
    exp = [7, 2, 8, 1]
    result = input.map {|x| MM::Deltas.abs(x)}
    assert_equal exp, result
  end
  def test_mean_inter_delta
    input = [[5, 4, 3, 6], [12, 2, 11, 7]]
    exp = [4.5, 8]
    result = input.map {|x| MM::Deltas.mean(x)}
    assert_equal exp, result
  end
  def test_distance_ordered_inter_delta
    input = [[-1, -1], [1, 1], [-1, 1], [-1, -1]]
    exp = [0, 0, 2, 0]
    result = input.map {|x| MM::Deltas.abs(x)}
    assert_equal exp, result
  end
end

