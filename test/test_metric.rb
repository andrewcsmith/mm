require 'minitest/autorun'

require 'mm/metric'

class TestMetric < Minitest::Test
  def setup
    @order ||= true
    @pair ||= :linear
    @scale ||= :none
    @intra_delta ||= :abs
    @inter_delta ||= :abs
    @metric = MM::Metric.new(@order, @pair, @scale, @intra_delta, @inter_delta)

    # Setting up the sample vectors for many of the examples
    @v1 = [1, 6, 2, 5, 11]
    @v2 = [3, 15, 13, 2, 9]
  end

  def test_creates_new_metric
    assert @metric.is_a? MM::Metric
  end

  def test_metric_responds_to_call 
    assert_respond_to @metric, :call 
  end

  class TestGetPairs < self
    class TestLinearPairs < self
      def test_gets_linear_pairs
        exp = [
          [[1, 6], [6, 2], [2, 5], [5, 11]],
          [[3, 15], [15, 13], [13, 2], [2, 9]]
        ]
        assert_equal exp, @metric.get_pairs(@v1, @v2)
      end
    end

    class TestCombinatorialPairs < self
      def setup
        @pair = :combinatorial
        super
      end

      def test_gets_combinatorial_pairs
        exp = [
          [[1, 6], [1, 2], [1, 5], [1, 11], [6, 2], [6, 5],
            [6, 11], [2, 5], [2, 11], [5, 11]],
          [[3, 15], [3, 13], [3, 2], [3, 9], [15, 13], [15, 2],
            [15, 9], [13, 2], [13, 9], [2, 9]]
        ]
        assert_equal exp, @metric.get_pairs(@v1, @v2)
      end
    end
  end

  class TestDeltas
    def setup
      super
    end
  end

  class TestMagnitudeMetric < self
    def test_gets_intra_delta
      pairs = [
        [[1, 6], [6, 2], [2, 5], [5, 11]],
        [[3, 15], [15, 13], [13, 2], [2, 9]]
      ]
      exp = [
        [5, 4, 3, 6],
        [12, 2, 11, 7]
      ]
      assert_equal exp, @metric.intra_delta(pairs)
    end

    def test_gets_inter_delta
      diffs = [
        [5, 4, 3, 6],
        [12, 2, 11, 7]
      ]
      exp = [7, 2, 8, 1]
      assert_equal exp, @metric.inter_delta(diffs) 
    end

    def test_measures_vectors
      assert_equal 4.5, @metric.call(@v1, @v2)
    end
  end
end

