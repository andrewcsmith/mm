require 'mm/search'
require_relative '../helpers.rb'

class TestMM < Minitest::Test; end

class TestMM::TestSearch < Minitest::Test
  include TestHelpers

  def setup
    @starting_point = 0.4
    @search = MM::Search.new(@starting_point)
  end
  def test_search_exists
    refute @search.nil?
  end
  def test_cost_function_accessor
    @search.cost_function = ->(){0.5}
    assert_equal 0.5, @search.cost_function
  end
  def test_calculate_cost_gets_cost_for_candidates
    @search.cost_function = ->(x){x - 0.1}
    candidates = [0.3, 0.5]
    assert_nested_in_delta [0.2, 0.4], @search.calculate_cost(candidates)
  end
  def test_current_cost_initially_gets_cost_of_starting_point
    @search.cost_function = ->(x){x - 0.1}
    assert_in_delta 0.3, @search.current_cost
  end
  def test_current_cost_gets_cost_of_current_point
    @search.cost_function = ->(x){x - 0.1}
    @search.instance_variable_set(:@current_point, 0.3)
    assert_in_delta 0.2, @search.current_cost
  end
  def test_adjacent_points_function_accessor
    @search.adjacent_points_function = ->(current) {[-0.1, 0.1].map {|x| current + x}}
    assert_nested_in_delta [0.3, 0.5], @search.get_adjacent_points
  end

  # Testing the final #find method!
  def test_find
    @search.adjacent_points_function = ->(current) {[-0.1, 0.1].map {|x| current + x}}
    @search.cost_function = ->(x){x - 0.1}
    assert_in_delta 0.1, @search.find
  end
  def test_find_returns_nil_when_nothing_found
    @search.delta = 0.0
    @search.starting_point = [0.1, 0.2, 0.3]
    @search.adjacent_points_function = ->(current) {current.repeated_combination(3)}
    @search.cost_function = ->(x) { x.inject(0, :+) / x.size }
    assert_equal nil, @search.find
  end
  def test_backtrack_removes_point_and_adds_it_to_banned
    @search.path = [0.1, 0.2]
    @search.backtrack
    assert_equal [0.1], @search.path
    assert_equal [0.2], @search.banned
  end
end

