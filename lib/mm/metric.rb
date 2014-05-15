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

    def protected_use_method mod, var, sym
      if sym.is_a?(Symbol) && mod.respond_to?(sym)
        self.instance_variable_set(var, mod.method(sym))
      else
        self.instance_variable_set(var, sym)
      end
    end

    def pair= pair
      protected_use_method(MM::Pairs.new, :@pair, pair)
    end

    def scale= scale
      protected_use_method(MM::Scaling, :@scale, scale)
    end

    def intra_delta= intra_delta
      protected_use_method(MM::Deltas, :@intra_delta, intra_delta)
    end

    def inter_delta= inter_delta
      protected_use_method(MM::Deltas, :@inter_delta, inter_delta)
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

    # Performs final summing and scaling on the output of inter_delta.
    # Can be overwritten when subclassed, in case you want to use a 
    # different method of averaging (sum of squares, etc.)
    #
    # @param diffs [#reduce] The vector of the differences between
    #   the two vector deltas. Essentially the output of inter_delta.
    #
    # @param size [Numeric] The size to divide by. Usually the size
    #   of one of the vector_deltas.
    #
    # @return distance [Numeric] The distance calculated by the diff
    #
    def post_scale diffs, size
      diffs.reduce(0, :+).to_f / size
    end

    # Gets the distance between two vectors, according to the Metric object.
    #
    # == Parameters:
    # v1::
    #   The vector to call on.
    #
    # v2::
    #   The vector to compare against.
    #
    # == Returns:
    # A float distance between the two vectors.
    def call v1, v2
      pairs = get_pairs v1, v2
      vector_deltas = scale(intra_delta(pairs))
      diffs = inter_delta(vector_deltas)
      post_scale diffs, pairs[0].size
    end
  end
end

