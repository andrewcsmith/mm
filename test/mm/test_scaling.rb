require 'mm/scaling'
require_relative '../helpers.rb'

class TestMM < Minitest::Test; end

class TestMM::TestScaling < Minitest::Test
  include TestHelpers

  def setup
    @n = [4, 3, 6, 2]
    @m = [3, 4, 1, 2]
  end
  def test_absolute_scaling
    expected = [[0.667, 0.5, 1.0, 0.333],
                [0.5, 0.667, 0.167, 0.333]]
    result = MM::Scaling.absolute([@n, @m])
    assert_nested_in_delta_2_deep expected, result
  end
  def test_relative_scaling
    expected = [[0.667, 0.5, 1.0, 0.333],
                [0.75, 1.0, 0.25, 0.5]]
    result = MM::Scaling.relative([@n, @m])
    assert_nested_in_delta_2_deep expected, result
  end
  def test_get_global_scaling
    expected = [[0.5, 0.375, 0.75, 0.25],
                [0.375, 0.5, 0.125, 0.25]]
    result = MM::Scaling.get_global(8.0).call([@n, @m])
    assert_nested_in_delta_2_deep expected, result
  end
end

