require "nmatrix"

class VectorMachine
  def get_adjacent_pairs(vector)
    # get the shape of the pairs vector
    out_shape = vector.shape << 2
    out_shape[0] -= 1
    
    out = NMatrix.zeros(out_shape, dtype: vector.dtype)
    # out_new_shape = out.rank(0, 0...out.shape[0]-1).shape
    # first = NMatrix.new(out_new_shape, vector.rank(0, 0...vector.shape[0]-1).to_a.flatten, dtype: vector.dtype)
    # second = NMatrix.new(out_new_shape, vector.rank(0, 1...vector.shape[0]).to_a.flatten, dtype: vector.dtype)
    out.rank(out.dim-1, 0, :reference)[:*, :*, :*] = vector.rank(0, 0...vector.shape[0]-1)
    out.rank(out.dim-1, 1, :reference)[:*, :*, :*] = vector.rank(0, 1...vector.shape[0])
    
  end
end
