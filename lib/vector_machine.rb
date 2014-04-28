require "nmatrix"

class VectorMachine
  
  # Given an n-dimensional NMatrix, returns an NMatrix made up of the adjacent pairs
  def get_adjacent_pairs(vector)
    out_shape = vector.shape << 2
    out_shape[0] -= 1
    
    out = NMatrix.zeros(out_shape, dtype: vector.dtype, stype: vector.stype)
    args = out.shape.map {:*}
    
    out_shape[0] -= 1
    out.rank(0, 0, :reference)[*args]= vector.rank(0, 0...vector.shape[0]-1).reshape(out_shape)
    out.rank(0, 1, :reference)[*args]= vector.rank(0, 1...vector.shape[0]).reshape(out_shape)
    out
  end
  
  # IDEA: use matrix multiplication as a way to reshape
  # except this will only work for 2 dimensional sources at the most
  # and the columns have to be the same in both versions
  def get_combinatorial_pairs(vector)
    # getting the combinations via a normal array
    combos = vector.to_a.combination(2).to_a.flatten
    # add the two spaces to the vector's shape
    out_shape = vector.shape << 2
    # outer dimension is # of possible combinations
    out_shape[0] = (out_shape[0]-1).downto(1).reduce(:+)
    # set up the output matrix
    out = NMatrix.new(out_shape, combos, dtype: vector.dtype, stype: vector.stype)
    # this should be sufficient for now
    out
  end
end
