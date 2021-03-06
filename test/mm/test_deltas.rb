require 'mm/deltas'
require_relative '../helpers.rb'

class TestMM < Minitest::Test; end

class TestMM::TestDeltas < Minitest::Test
  include TestHelpers

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

  def test_tenney_ordered_intra_delta
    input = [[Rational(1,1), Rational(3,2)], [Rational(3,2), Rational(5,4)]]
    exp = [2.585, 4.907]
    assert_nested_in_delta exp, input.map {|x| MM::Deltas.tenney(x)}
  end

  def test_log_ratio_ordered_intra_delta
    input = [[Rational(1,1), Rational(3,2)], [Rational(3,2), Rational(5,4)]]
    exp = [0.585, 0.263]
    assert_nested_in_delta exp, input.map {|x| MM::Deltas.log_ratio(x)}
  end

  def test_ratio_ordered_intra_delta
    input = [[Rational(1,1), Rational(3,2)], [Rational(3,2), Rational(5,4)]]
    exp = [Rational(2,3), Rational(6,5)]
    assert_nested_in_delta exp, input.map {|x| MM::Deltas.ratio(x)}
  end
end

