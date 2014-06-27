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
    result.zip(expected) do |x|
      x[0].zip(x[1]) do |y| 
        assert_in_delta *y, 0.001
      end
    end
  end
  def test_relative_scaling
    expected = [[0.667, 0.5, 1.0, 0.333],
                [0.75, 1.0, 0.25, 0.5]]
    result = MM::Scaling.relative([@n, @m])
    result.zip(expected) do |x|
      x[0].zip(x[1]) do |y| 
        assert_in_delta *y, 0.001
      end
    end
  end
end

