module MM
  class Metric
    def initialize o, p, s, ad, rd
      @ordered = o
      self.pair = p
      self.scale = s
      self.intra_delta = ad
      self.inter_delta = rd
    end

    attr_accessor :ordered

    def pair= pair
      @pair = MM::PAIR_FUNCTIONS[pair] || pair
    end

    def scale= scale
      if MM::Scaling.respond_to? scale
        @scale = MM::Scaling.method scale
      else
        @scale = scale
      end
    end

    def intra_delta= intra_delta
      @intra_delta = MM::DELTA_FUNCTIONS[intra_delta] || intra_delta
    end

    def inter_delta= inter_delta
      @inter_delta = MM::DELTA_FUNCTIONS[inter_delta] || inter_delta
    end

    # Returns an Array of a pair of elements, where each is a vector of pairs
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
      if @ordered
        return diffs[0].zip(diffs[1]).map {|x| @inter_delta.call(x)}
      else
        diffs.map {|x| x.inject(0, :+).to_f / x.size}
      end
    end

    # Method, so that if you want to subclass Metric you totally can
    def scale pairs
      @scale.call pairs
    end

    # Default just takes the mean of everything. Try sum of squares?
    def post_scale diffs, size
      diffs.reduce(0, :+).to_f / size
    end

    def call v1, v2
      pairs = get_pairs v1, v2
      vector_deltas = scale(intra_delta(pairs))
      diffs = inter_delta(vector_deltas)
      post_scale diffs, pairs[0].size
    end
  end
end

