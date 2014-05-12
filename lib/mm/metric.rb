module MM
  class Metric
    def initialize order, pair, scale, intra_delta, inter_delta
      @order = order
      @pair = MM::PAIR_FUNCTIONS[pair] || pair
      @scale = MM::SCALING_FUNCTIONS[scale] || scale
      @intra_delta = MM::DELTA_FUNCTIONS[intra_delta] || intra_delta
      @inter_delta = MM::DELTA_FUNCTIONS[inter_delta] || inter_delta
    end

    attr_writer :intra_delta, :inter_delta

    def get_pairs v1, v2
      [v1, v2].map {|x| @pair.call(x)}
    end

    # Applies the delta to each pair of elements in a collection
    # where each pair is [elem1, elem2]
    def intra_delta vp
      vp.map {|x| x.map {|n| @intra_delta.call(n)}}
    end

    # Applies to elements at the same index over either collection
    def inter_delta diffs
      diffs[0].zip(diffs[1]).map {|x| @inter_delta.call(x)}
    end

    # Deliberate choice to make this a method rather than stick with the Proc.
    # This enables someone subclassing Metric to have a faster implementation
    # by circumventing the Proc and overwriting the #scale method.
    def scale diffs, size
      @scale.call(diffs, size)
    end

    def call v1, v2
      pairs = get_pairs v1, v2
      # Replaces each pair with its difference in each vector
      diffs = inter_delta(intra_delta(pairs))
      # Sum over the differences and scale
      scale diffs, pairs[0].size
    end
  end
end

