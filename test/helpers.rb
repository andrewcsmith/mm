module TestHelpers
  # Asserts that each item in exp matches each item in act
  def assert_nested_in_delta exp, act, delta = 0.001, msg = nil 
    exp.zip(act) do |x|
      if block_given?
        yield x, delta, msg
      else
        assert_in_delta(*x, delta, msg)
      end
    end
  end

  # Asserts that nested values 2-deep are within a certain delta
  def assert_nested_in_delta_2_deep *args
    assert_nested_in_delta(*args) do |x, delta, msg|
      x[0].zip(x[1]) do |y|
        assert_in_delta(*y, delta, msg)
      end
    end
  end
end

