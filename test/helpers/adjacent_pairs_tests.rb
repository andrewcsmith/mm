# Some tests that should pass with all expectation setups
module VMSanityTests
  def test_nmatrix_sanity
    assert_equal @exp_array, @exp.to_a 
  end
end

module AdjacentPairsTests
  def test_gets_adjacent_pairs
    assert_equal @exp, @pairs.get_adjacent_pairs(@m)
  end
  
  def test_gets_adjacent_pairs_large
    assert_equal @exp, @pairs.get_adjacent_pairs_large(@m)
  end
end

module CombinatorialPairsTests
  def test_gets_combinatorial_pairs
    assert_equal @exp, @pairs.get_combinatorial_pairs(@m)
  end
end

