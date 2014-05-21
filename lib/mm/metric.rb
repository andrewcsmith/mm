module MM
  class Metric
    def initialize(ordered: true, pair: nil, scale: nil, intra_delta: nil, inter_delta: nil, **options)
      @ordered = ordered
      self.pair = pair
      self.scale = scale
      self.intra_delta = intra_delta
      self.inter_delta = inter_delta
      @options = options
      @scale_size = 1.0
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
      pairs = [v1, v2].map {|x| @pair.call(x)}
      @scale_size = @ordered ? pairs[0].size : 1.0
      pairs
    end

    # Applies the delta to each pair of elements in a collection
    # where each pair is [elem1, elem2]
    # 
    # vp      - vector pairs
    #
    # Returns the vector_deltas, which is the difference between each pair of
    # elements in a given vector.
    def intra_delta vp
      vp.map {|x| x.map {|n| @intra_delta.call(*n)}}
    end

    # Applies to elements at the same index over either collection
    def inter_delta diffs
      if @ordered
        return diffs[0].zip(diffs[1]).map {|x| @inter_delta.call(*x)}
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
    # diffs - [#reduce] The vector of the differences between
    #   the two vector deltas. Essentially the output of inter_delta.
    #
    # size - [Numeric] The size to divide by. Usually the size
    #   of one of the vector_deltas.
    #
    # Returns distance [Numeric] The distance calculated by the diff
    def post_scale diffs
      diffs.reduce(0, :+).to_f / @scale_size
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
      pairs = get_pairs(v1, v2)
      vector_deltas = scale(intra_delta(pairs))
      diffs = inter_delta(vector_deltas)
      post_scale diffs
    end

    ### CONVENIENCE CREATION METHODS ###
    # ::olm
    # ::ocm
    # ::ulm
    # ::ucm
    # ::old
    # ::ocd
    # ::uld
    # ::ucd
    #
    METHOD_SHORTCUTS = {
      :olm => {:ordered => true, :pair => :linear, :scale => :none, :intra_delta => :abs, :inter_delta => :abs},
      :ocm => {:ordered => true, :pair => :combinatorial, :scale => :none, :intra_delta => :abs, :inter_delta => :abs},
      :ulm => {:ordered => false, :pair => :linear, :scale => :none, :intra_delta => :abs, :inter_delta => :abs},
      :ucm => {:ordered => false, :pair => :combinatorial, :scale => :none, :intra_delta => :abs, :inter_delta => :abs},
      :old => {:ordered => true, :pair => :linear, :scale => :none, :intra_delta => :direction, :inter_delta => :abs},
      :ocd => {:ordered => true, :pair => :combinatorial, :scale => :none, :intra_delta => :direction, :inter_delta => :abs},
      :uld => {:ordered => false, :pair => :linear, :scale => :none, :intra_delta => :direction, :inter_delta => :abs},
      :ucd => {:ordered => false, :pair => :combinatorial, :scale => :none, :intra_delta => :direction, :inter_delta => :abs}
    }

    class << self
      METHOD_SHORTCUTS.each do |k, v|
        define_method k do |other = {}|
          new((v.merge other))
        end
      end
    end
    
    # def self.olm(scale = :none, intra_delta = :abs, inter_delta = :abs)
    #   self.new(true, :linear, scale, intra_delta, inter_delta)
    # end

  end
end

