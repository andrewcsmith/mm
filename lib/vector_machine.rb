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

  # Adjacent pairs of an NMatrix's outermost dimension
  #
  # Benchmarking results:
  # bench_get_adjacent_pairs_1d  0.000162  0.000469  0.004219  0.069569  0.704543
  #   def get_adjacent_pairs(vector)
  #     out_shape = get_pairs_shape(vector)
  #     out = NMatrix.zeros(out_shape, dtype: vector.dtype, stype: vector.stype)
  #     
  #     args = out.shape.map {:*}
  #     
  #     out_shape[0] -= 1
  #     out.rank(0, 0, :reference)[*args]= vector.rank(0, 0...vector.shape[0]-1).reshape(out_shape)
  #     out.rank(0, 1, :reference)[*args]= vector.rank(0, 1...vector.shape[0]).reshape(out_shape)
  #     out
  #   end
  # 
  # alias :get_adjacent_pairs_old :get_adjacent_pairs

  # Adjacent pairs of an NMatrix's outermost dimension
  #
  # Benchmarking results:
  # bench_get_adjacent_pairs_1d  0.000079  0.000115  0.000795  0.008025  0.100932
  def get_adjacent_pairs(vector)
    # still have to define the out_shape separately
    out_shape = get_pairs_shape(vector)
    a_vec = vector.to_a
    memo = []
    (0...a_vec.size-1).each do |i|
      memo << [a_vec[i], a_vec[i+1]]
    end
    NMatrix.new(out_shape, memo.flatten)
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
