require 'yaml'

module MM
  class Metric
    # Constructor for the Metric object.
    #
    # ordered - [Boolean] 
    #   Controls whether metric is ordered
    # pair - [Symbol, #call] 
    #   Method of +MM::Deltas+, or where +Object#call+ returns an +Array+ of
    #   pairs.
    # scale - [Symbol, #call] 
    #   Method of +MM::Scaling+, or where +Object#call+ returns a scaled diff
    #   +Array+
    # intra_delta - [Symbol, #call] 
    #   Method of +MM::Deltas+, or where +Object#call+ returns +Array+ of
    #   differences between pairs of elements
    # inter_delta - [Symbol, #call] 
    #   Method of +MM::Deltas+, or where +Object#call+ returns +Array+ of
    #   differences between the diffs of the two input morphologies
    # 
    def initialize(ordered: true, pair: nil, scale: nil, intra_delta: nil, inter_delta: nil)
      @ordered = ordered
      self.pair = pair
      self.scale = scale
      self.intra_delta = intra_delta
      self.inter_delta = inter_delta
    end

    attr_accessor :ordered

    # Public: Gets the distance between two vectors, according to the Metric
    # object. Since +Metric+ can be duck-typed to work with +intra_delta+ and
    # +inter_delta+, it should be possible to nest +Metric+ objects.
    #
    # v1 - The vector to call on.
    # v2 - The vector to compare against.
    #
    # Returns a [Float] distance between the two vectors.
    def call v1, v2
      # "Readable" method provided for the parenthetically inclined
      # inter_delta(scale(intra_delta(get_pairs(v1, v2))))
      inter_delta scale intra_delta get_pairs v1, v2
    end

    # Public: Setter method for pair.
    #
    # pair - [Symbol, #call] 
    #   Method of +MM::Deltas+, or where +Object#call+ returns an +Array+ of
    #   pairs.
    #
    # Returns a [Proc] pair.
    def pair= pair
      protected_use_method(MM::Pairs.new, :@pair, pair)
    end

    # Public: Setter method for scale.
    #
    # scale - Either a Proc that can process scaling, or a Symbol to look up in
    #   MM::Scaling.
    #
    # Returns scale.
    def scale= scale
      protected_use_method(MM::Scaling, :@scale, scale)
    end

    # Public: Setter method for intra_delta.
    #
    # intra_delta - Either a Proc that can process the intra_delta, or a Symbol
    #   to look up in MM::Deltas.
    #
    # Returns intra_delta.
    def intra_delta= intra_delta
      protected_use_method(MM::Deltas, :@intra_delta, intra_delta)
    end

    # Public: Setter method for inter_delta.
    #
    # inter_delta - Either a Proc that can process as an inter_delta, or a
    #   Symbol where +MM::Deltas.respond_to? Symbol == true+
    #
    # Returns itself. Sets the instance variable @inter_delta.
    def inter_delta= inter_delta
      protected_use_method(MM::Deltas, :@inter_delta, inter_delta)
    end

    private

    # Private: Calls the get_pairs Proc on each of v1 and v2. In lp's
    # terminology, the get_pairs Proc should return either adjacent  pairs
    # of each of the two vectors (for linear metrics) or all possible pair
    # combinations (for combinatorial metrics). For more, see Polansky 1992.
    # 
    # v1 - the metric to use as a base
    # v2 - the metric to compare to
    #
    # Returns an Array of Arrays of pairs.
    def get_pairs v1, v2
      [v1, v2].map {|x| @pair.call(x)}
    end

    # Private: Applies the delta to each pair of elements in a collection
    # where each pair is [elem1, elem2]
    # 
    # vp - vector pairs
    #
    # Returns the vector_deltas, which is the difference between each pair of
    # elements in a given vector.
    def intra_delta vp
      vp.map {|x| x.map {|n| @intra_delta.call(n)}}
    end

    # Private: Calls the scaling Proc. It's a Method, so if you want to subclass it when
    # subclassing Metric (in order to do something fast and crazy) you totally can.
    #
    # pairs - A sequence of pairs.
    #
    # Returns the output of the scaling Proc, ideally a sequence of pairs.
    def scale pairs
      @scale.call pairs
    end

    # Private: Accepts a series of vectors, either a sequence of pairs or two full
    # collections, and reduces them to a single vector. Does not do any scaling.
    #
    # diffs - [Enumerable] Series of vectors, either a sequence of pairs or two full
    #   collections.
    #
    # Returns a single vector of the diffs between the two.
    def inter_delta diffs
      if @ordered
        # Ordered Metrics take the mean of differences
        Deltas.mean(diffs[0].zip(diffs[1]).map {|x| @inter_delta.call x})
      else
        # Unordered Metrics take the difference of means
        Deltas.abs(diffs.map {|x| @inter_delta.call x})
      end
    end

    # Private: Performs final averaging on the output of inter_delta. Can be overwritten
    # when subclassed, in case you want to use a different method of averaging
    # (sum of squares, etc.)
    #
    # diffs - The vector of the differences between the two vector deltas. Essentially 
    #   the output of inter_delta. Should respond to #reduce.
    #
    # Returns distance [Numeric] The distance calculated by the diff
    def post_scale diffs
      diffs.reduce(0, :+).to_f / diffs.size
    end

    # Private: Assigns the Method named sym, if mod responds to it, to the
    # instance variable var. Otherwise, assumes that the sym is actually a Proc
    # and just tries to use it straight.
    #
    # mod - Object to see whether it has a method.
    # var - instance variable to assign to.
    # sym - Symbol to lookup in mod's exposed methods.
    #
    # Returns +sym+.
    def protected_use_method mod, var, sym
      if sym.is_a?(Symbol) && mod.respond_to?(sym)
        self.instance_variable_set(var, mod.method(sym))
      else
        self.instance_variable_set(var, sym)
      end
    end

    ### CONVENIENCE CREATION METHODS ###
    # All of the following methods are created using the YAML definition file.
    # See shortcuts.yml for the full definition.
    # ::olm
    # ::ocm
    # ::ulm
    # ::ucm
    # ::old
    # ::ocd
    # ::uld
    # ::ucd
    METHOD_SHORTCUTS = YAML.load(File.read(File.join(File.dirname(__FILE__), '..', 'shortcuts.yml')))

    class << self
      METHOD_SHORTCUTS.each do |k, v|
        define_method k do |other = {}|
          new((v.merge other))
        end
      end
    end
  end
end

