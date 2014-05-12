# require "minitest/autorun"

require "mm/pairs"
require "helpers/adjacent_pairs_tests.rb"

class TestOneDimensionalNMatrix < Minitest::Test
  def setup
    @pairs = MM::Pairs.new
    @m = ::NMatrix.seq([3])
  end

  class TestAdjacentPairs < self 
    def setup
      super
      @exp_array = [[0, 1], [1, 2]]
      @exp = NMatrix.new([2, 2], @exp_array.flatten)
    end
    include VMSanityTests
    include AdjacentPairsTests
  end

  class TestCombinatorialPairs < self 
    def setup
      super
      @exp_array = [[0, 1], [0, 2], [1, 2]]
      @exp = NMatrix.new([3, 2], @exp_array.flatten)
    end
    include VMSanityTests
    include CombinatorialPairsTests
  end
end

class TestTwoDimensionalNMatrix < Minitest::Test
  def setup
    @pairs = MM::Pairs.new
    @m = ::NMatrix.seq([3, 2])
  end

  class TestAdjacentPairs < self
    def setup
      super
      @exp_array = [[[0, 1], [2, 3]], [[2, 3], [4, 5]]]
      @exp = NMatrix.new([2, 2, 2], @exp_array.flatten)
    end
    include VMSanityTests
    include AdjacentPairsTests
  end

  class TestCombinatorialPairs < self
    def setup
      super
      @exp_array = [
        [[0, 1], [2, 3]],
        [[0, 1], [4, 5]],
        [[2, 3], [4, 5]]
      ]
      @exp = NMatrix.new([3, 2, 2], @exp_array.flatten)
    end
    include VMSanityTests
    include CombinatorialPairsTests
  end
end

class TestThreeDimensionalNMatrix < Minitest::Test
  def setup
    @pairs = MM::Pairs.new
    @m = ::NMatrix.seq([4,3,2])
  end

  class TestAdjacentPairs < self
    def setup
      super
      @exp_array = [
        [[[0, 1], [2, 3], [4, 5]], [[6, 7], [8, 9], [10, 11]]],
        [[[6, 7], [8, 9], [10, 11]], [[12, 13], [14, 15], [16, 17]]],
        [[[12, 13], [14, 15], [16, 17]], [[18, 19], [20, 21], [22, 23]]]
      ]
      @exp = NMatrix.new([3, 2, 3, 2], @exp_array.flatten)
    end
    include AdjacentPairsTests
    include VMSanityTests
  end

  # TODO: Implement combinatorial pairs in 3 dimension
end

class TestOneDimensionalArray < Minitest::Test
  def setup
    @pairs = MM::Pairs.new
    @m = [0, 1, 2]
  end

  class TestAdjacentPairs < self
    def setup
      super
      @exp = [[0, 1], [1, 2]]
    end

    include AdjacentPairsTests

    alias :old_test_gets_adjacent_pairs_large :test_gets_adjacent_pairs_large
    def test_gets_adjacent_pairs_large
      assert_raises(ArgumentError) do 
        old_test_gets_adjacent_pairs_large
      end
    end
  end

  class TestCombinatorialPairs < self
    def setup
      super
      @exp = [[0, 1], [0, 2], [1, 2]]
    end

    include CombinatorialPairsTests
  end
end

class TestTwoDimensionalArray < Minitest::Test
  def setup
    @pairs = MM::Pairs.new
    @m = [[0, 1], [2, 3], [4, 5]]
  end
   
  class TestAdjacentPairs < self
    def setup
      super
      @exp = [[[0, 1], [2, 3]], [[2, 3], [4, 5]]]
    end
    
    include AdjacentPairsTests
    
    alias :old_test_gets_adjacent_pairs_large :test_gets_adjacent_pairs_large
    def test_gets_adjacent_pairs_large
      assert_raises(ArgumentError) do 
        old_test_gets_adjacent_pairs_large
      end
    end
  end
end

