require 'mm/ratio'

class TestMM < Minitest::Test; end

class TestMM::TestRatio < Minitest::Test
  def setup
    @ratio = MM::Ratio.new(3,2)
  end

  def test_numerator
    assert_equal 3, @ratio.numerator
  end

  def test_denominator
    assert_equal 2, @ratio.denominator
  end

  def test_multiplication
    mul = @ratio * MM::Ratio.new(5,4)
    assert_equal MM::Ratio.new(15,8), mul
  end

  def test_multiplication_reduces
    mul = @ratio * MM::Ratio.new(10,9)
    assert_equal MM::Ratio.new(5,3), mul
  end

  def test_division
    div = @ratio / MM::Ratio.new(5,4)
    assert_equal MM::Ratio.new(6,5), div
  end

  def test_from_s_single
    assert_equal @ratio, MM::Ratio.from_s("3/2")
  end

  def test_from_s_array
    assert_equal [@ratio, @ratio], MM::Ratio.from_s(%w(3/2 3/2))
  end

  def test_from_s_list
    assert_equal [@ratio, @ratio], MM::Ratio.from_s("3/2 3/2")
  end

  def test_from_s_multi_digit
    assert_equal MM::Ratio.new(10,9), MM::Ratio.from_s("10/9")
  end

  def test_to_f
    assert_equal 1.5, @ratio.to_f
  end

  def test_to_s
    assert_equal "3/2", @ratio.to_s
  end

  def test_plus
    assert_equal MM::Ratio.new(3,1), @ratio + @ratio
  end

  def test_minus
    assert_equal MM::Ratio.new(5,6), @ratio - @ratio.reciprocal
  end

  def test_reciprocal
    assert_equal MM::Ratio.new(2,3), @ratio.reciprocal
  end

  def test_reads_ratios_from_yaml
    ratios = MM::Ratio.from_yaml(<<-YAML)
- 1/1
- 10/9
- 5/4
    YAML
    exp = [MM::Ratio.new(1,1), MM::Ratio.new(10,9), MM::Ratio.new(5,4)]
    assert_equal exp, ratios
  end

  def test_to_vector
    point = [MM::Ratio.new(1,1), MM::Ratio.new(3,2), MM::Ratio.new(5,4)]
    exp = [MM::Ratio.new(2,3), MM::Ratio.new(6,5)]
    assert_equal exp, MM::Ratio.to_vector(point)
  end

  def test_from_vector
    vector = [MM::Ratio.new(2,3), MM::Ratio.new(6,5)]
    exp = [MM::Ratio.new(1,1), MM::Ratio.new(3,2), MM::Ratio.new(5,4)]
    assert_equal exp, MM::Ratio.from_vector(vector)
  end

  def test_change_interval
    point = [MM::Ratio.new(1,1), MM::Ratio.new(3,2), MM::Ratio.new(5,4)]
    exp = [MM::Ratio.new(1,1), MM::Ratio.new(4,3), MM::Ratio.new(10,9)]
    assert_equal exp, MM::Ratio.change_interval(point, 0, MM::Ratio.new(3,4))
  end

  def test_change_interval_reciprocal
    point = [MM::Ratio.new(1,1), MM::Ratio.new(3,2), MM::Ratio.new(5,4)]
    exp = [MM::Ratio.new(1,1), MM::Ratio.new(2,3), MM::Ratio.new(5,9)]
    assert_equal exp, MM::Ratio.change_interval(point, 0, :reciprocal)
  end
end

