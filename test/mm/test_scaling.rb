require 'mm/scaling'

class TestMM < Minitest::Test; end

class TestMM::TestScaling < Minitest::Test
  def setup
    @n = [4, 3, 6, 2]
    @m = [3, 4, 1, 2]
  end
  def test_absolute_scaling
    expected = [[0.667, 0.5, 1.0, 0.333],
                [0.5, 0.667, 0.167, 0.333]]
    result = MM::Scaling.absolute([@n, @m])
    assert_nested_values expected, result
  end
  def test_relative_scaling
    expected = [[0.667, 0.5, 1.0, 0.333],
                [0.75, 1.0, 0.25, 0.5]]
    result = MM::Scaling.relative([@n, @m])
    assert_nested_values expected, result
  end
  def test_get_global_scaling
    expected = [[0.5, 0.375, 0.75, 0.25],
                [0.375, 0.5, 0.125, 0.25]]
    result = MM::Scaling.get_global(8.0).call([@n, @m])
    assert_nested_values expected, result
  end

  # Asserts that nested values 2-deep are within a certain delta
  def assert_nested_values exp, act, delta = 0.001, msg = nil
    exp.zip(act) do |x|
      x[0].zip(x[1]) do |y|
        assert_in_delta(*y, delta, msg)
      end
    end
  end
end

