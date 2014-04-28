$:.unshift File.join(File.dirname(File.expand_path(__FILE__)), "../lib")

require "minitest/autorun"
require "minitest/benchmark"
require "vector_machine"

class TestVectorMachine < Minitest::Benchmark
  def setup
    @m = ::NMatrix.new([3], [0, 1, 2])
    @vm = VectorMachine.new
  end

  def self.bench_range
    [1, 10, 100, 1000, 10000]
  end
  
  def bench_get_adjacent_pairs_1d
    assert_performance_linear 0.999 do |n|
      n.times do
        @vm.get_adjacent_pairs(@m)
      end
    end
  end

  def bench_large_adjacent_pairs_old_1d
    @m = ::NMatrix.random([2048])
    assert_performance_linear 0.999 do |n|
      n.times do
        @vm.get_adjacent_pairs_old @m
      end
    end
  end



  def bench_large_adjacent_pairs_1d
    @m = ::NMatrix.random([2048])
    assert_performance_linear 0.999 do |n|
      n.times do
        @vm.get_adjacent_pairs @m
      end
    end
  end

  def bench_gets_combinatorial_pairs_1d
    assert_performance_linear 0.999 do |n|
      n.times do
        @vm.get_combinatorial_pairs(@m)
      end
    end
  end

  def bench_gets_combinatorial_pairs_2d
    @m = N[[0, 1], [0, 2], [1, 2]]
    assert_performance_linear 0.999 do |n|
      n.times do
        @vm.get_combinatorial_pairs(@m)
      end
    end
  end
end

