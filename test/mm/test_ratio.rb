require 'mm/ratio'

class TestMM; end

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
  def test_division
    div = @ratio / MM::Ratio.new(5,4)
    assert_equal MM::Ratio.new(6,5), div
  end
  def test_from_s_single
    assert_equal @ratio, MM::Ratio.from_s("3/2")
  end
  def test_from_s_list
    assert_equal [@ratio, @ratio], MM::Ratio.from_s(%w(3/2 3/2))
  end
end

