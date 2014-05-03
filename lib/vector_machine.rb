require "nmatrix"

class VectorMachine
  # TODO: Refactor so that we can call #adjacent_pairs on a Vector object
  def get_pairs_shape(vector, type = :adjacent)
    out_shape = vector.shape << 2
    if type == :adjacent
      out_shape[0] -= 1
    elsif type == :combinatorial
      out_shape[0] = (out_shape[0]-1).downto(1).reduce(:+)
    end
    out_shape
  end

  # TODO: Benchmark some extremely large Arrays, looking at the difference between NMatrix and Array.
  #       I have a hunch that NMatrix will do better on larger arrays than on smaller ones, because
  #       of the ovehead that it seems to be spending on creating the NMatrix objects.
  #
  # Adjacent pairs of an NMatrix's outermost dimension
  #
  # Benchmarking results:
  # bench_get_adjacent_pairs_1d  0.000162  0.000469  0.004219  0.069569  0.704543
  #
  def get_adjacent_pairs(vector)
    out_shape = get_pairs_shape(vector)
    out = NMatrix.zeros(out_shape, dtype: vector.dtype, stype: vector.stype)
      
    args = out_shape.map {:*}
      
    out_slice = out_shape.dup
    out_slice[0] -= 1
    out.rank(1, 0...out.shape[1]-1, :reference)[*args]= vector.rank(0, 0...vector.shape[0]-1)
    out.rank(1, 1...out.shape[1], :reference)[*args]= vector.rank(0, 1...vector.shape[0])
    out
  end

  alias :get_adjacent_pairs_old :get_adjacent_pairs

  def get_adjacent_pairs(vector)
    if vector.is_a? NMatrix
      # We only want the outer pair
      NMatrix.new(get_pairs_shape(vector), vector.to_a.each_cons(2).inject([], :<<).flatten)
    else
      # Fallback for anything Enumerable
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
    combos = vector.to_a.combination(2).to_a.flatten
    # get the proper shape
    out_shape = get_pairs_shape(vector, :combinatorial)
    # set up the output matrix
    NMatrix.new(out_shape, combos, dtype: vector.dtype, stype: vector.stype)
  end
end
