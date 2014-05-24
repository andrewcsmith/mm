require 'minitest/autorun'

require 'mm/metric'

class TestMM < Minitest::Test; end

class TestMM::TestMetric < Minitest::Test
  def setup
    @ordered ||= true
    @pair ||= :linear
    @scale ||= :none
    @intra_delta ||= :abs
    @inter_delta ||= :abs
    @metric = MM::Metric.new(ordered: @ordered, pair: @pair, scale: @scale, intra_delta: @intra_delta, inter_delta: @inter_delta)

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

  class TestDeltas < self
    class TestIntraDelta < self
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
      def test_intra_delta_proc
        @metric.intra_delta = ->(*vp) {nil}
        assert_instance_of Proc, @metric.instance_variable_get(:@intra_delta)
      end
    end

    class TestInterDelta < self
      def setup
        super
        @diffs = [
          [5, 4, 3, 6],
          [12, 2, 11, 7]
        ]
      end
      def test_gets_inter_delta_ordered
        exp = 4.5
        assert_equal exp, @metric.inter_delta(@diffs) 
      end
      def test_inter_delta_proc
        @metric.inter_delta = ->(*diffs) {nil}
        assert_instance_of Proc, @metric.instance_variable_get(:@inter_delta)
      end
    end
  end

  class TestScaling < self
    def setup
      super
      @unscaled = [
        [5, 4, 3, 6],
        [12, 2, 11, 7]
      ]
    end

    def test_assigns_scaling_proc
      @metric.scale = ->(pairs) {}
      assert_equal Proc, @metric.instance_variable_get(:@scale).class 
    end

    def test_gets_no_scaling
      assert_equal @unscaled, @metric.scale(@unscaled)
    end

    # TODO: This is a complicated test and I don't like it
    def test_gets_absolute_scaling
      @metric.scale = :absolute
      @exp = [
        [0.417, 0.333, 0.25, 0.5],
        [1.0, 0.167, 0.917, 0.583]
      ]
      actual = @metric.scale(@unscaled)
      actual.each_with_index do |v, i|
        v.each_with_index do |w, j|
          assert_in_delta @exp[i][j], w, 0.001 
        end
      end
    end

    def test_gets_relative_scaling
      @metric.scale = :relative
      @exp = [
        [0.833, 0.667, 0.5, 1.0],
        [1.0, 0.167, 0.917, 0.583]
      ]
      actual = @metric.scale(@unscaled)
      actual.each_with_index do |v, i|
        v.each_with_index do |w, j|
          assert_in_delta @exp[i][j], w, 0.001 
        end
      end
    end
  end

  class TestMagnitudeMetric < self
    @exp = {
      :olm => {:no_scaling => 4.5, :abs_scaling => 0.375},
      :ocm => {:no_scaling => 5.2, :abs_scaling => 0.4},
      :ulm => {:no_scaling => 3.5, :abs_scaling => 0.29167},
      :ucm => {:no_scaling => 2.4, :abs_scaling => 0.1846},
      :old => {:no_scaling => 0.25},
      :ocd => {:no_scaling => 0.4},
      :uld => {:no_scaling => 0.25},
      :ucd => {:no_scaling => 0.4}
    }
    @exp.each do |metric, expected|
      define_method("test_#{metric}_shorthand_no_scaling") do
        # skip("not implemented.")
        m = ::MM::Metric.send(metric)
        assert_in_delta expected[:no_scaling], m.call(@v1, @v2), 0.001
      end
      if expected[:abs_scaling]
        define_method("test_#{metric}_shorthand_abs_scaling") do
          # skip("not implemented.")
          m = ::MM::Metric.send(metric, {:scale => :absolute})
          assert_in_delta expected[:abs_scaling], m.call(@v1, @v2), 0.001
        end
      end
    end
  end
end

