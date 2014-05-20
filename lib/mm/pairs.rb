module MM
  class Pairs
    # Checks to see whether an Object responds to various methods. Raises
    # ArgumentError if #respond_to? returns false.
    #
    # obj       - Object to check for responses
    # methods   - Array of Symbols to check for response
    #
    # Returns true if all responses succeeded.
    def responds_to_arguments(obj, methods)
      methods.each do |x|
        if !obj.respond_to? x
          raise ArgumentError, "#{obj.class} does not implement #{x}"
        end
      end
      true
    end

    # General method to get adjacent pairs
    def get_adjacent_pairs(vector)
      vector.each_cons(2).to_a
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
      # out_shape = get_pairs_shape(vector, :combinatorial)
      # set up the output matrix
      # NMatrix.new(out_shape, combos.flatten, dtype: vector.dtype, stype: vector.stype)
      raise Exception, "oops."
    end

    alias_method :linear, :get_adjacent_pairs
    alias_method :combinatorial, :get_combinatorial_pairs
  end
end

