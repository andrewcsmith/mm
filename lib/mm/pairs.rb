require "nmatrix"

module MM
  class Pairs
    # Conenience method for getting the shape of a pairs array
    def get_pairs_shape(vector, type = :adjacent)
      out_shape = vector.shape
      if type == :adjacent
        out_shape[0] -= 1
        out_shape.insert 1, 2
      elsif type == :combinatorial
        out_shape << 2
        out_shape[0] = (out_shape[0]-1).downto(1).reduce(:+)
      end
      out_shape
    end

    def responds_to_arguments arg, methods
      methods.each do |x|
        if !arg.respond_to? x
          raise ArgumentError, "#{arg.class} does not implement #{x}"
        end
      end
    end

    # Gets the arguments to assign a
    # full slice
    def slice_args out
      out.shape.map {:*}
    end

    def get_pairs_output_vector vector
      NMatrix.zeros(get_pairs_shape(vector), dtype: vector.dtype, stype: vector.stype)
    end

    def pairs_args v, i, j
      [i, (j...(v.shape[i] - 1 + j))]
    end

    # Adjacent pairs of an NMatrix's outermost dimension
    # Optimized for use with large NMatrix objects (anything over 10 elements)
    # Note that all matrics must be the same size
    def get_adjacent_pairs_large(vector)
      responds_to_arguments vector, [:rank, :shape]
      # Set up the output matrix
      out = get_pairs_output_vector vector
      out.rank(*pairs_args(out, 1, 0), :reference)[*slice_args(out)]= vector.rank(*pairs_args(vector, 0, 0))
      out.rank(*pairs_args(out, 1, 1), :reference)[*slice_args(out)]= vector.rank(*pairs_args(vector, 0, 1))
      out
    end

    # General method to get adjacent pairs
    def get_adjacent_pairs(vector)
      if vector.is_a? NMatrix
        # We only want the outer pair
        NMatrix.new(get_pairs_shape(vector), vector.to_a.each_cons(2).inject([], :<<).flatten)
      else
        # Fallback for anything Enumerable, returns Array
        vector.each_cons(2).inject([], :<<)
      end
    end

    # Combinatorial pairs of an NMatrix's outermost dimension
    #
    # Benchmarking results [2014-04-28]:
    # 
    #     bench_gets_combinatorial_pairs_1d  0.000070  0.000149  0.001146  0.010921  0.147744
    #     bench_gets_combinatorial_pairs_2d  0.000115  0.000374  0.003322  0.037855  0.413232
    #
    def get_combinatorial_pairs(vector)
      # getting the combinations via the normal array method
      combos = vector.to_a.combination(2).to_a
      if vector.class == combos.class
        return combos
      end
      # get the proper shape
      # this should be obsolete once we have Array#to_nm fixed
      out_shape = get_pairs_shape(vector, :combinatorial)
      # set up the output matrix
      NMatrix.new(out_shape, combos.flatten, dtype: vector.dtype, stype: vector.stype)
    end
  end

  # Some Procs that make things easy to
  # drop in
  PAIR_FUNCTIONS = {
    :linear => ->(x) {Pairs.new.get_adjacent_pairs(x)},
    :combinatorial => ->(x) {Pairs.new.get_combinatorial_pairs(x)}
  }
end

