module MM; end

class MM::Search
  def initialize starting_point, delta = 0.001
    @starting_point = starting_point
    @delta = delta
    @current_point = @starting_point
  end

  attr_accessor :candidates, :delta, :starting_point
  attr_writer :cost_function, :adjacent_points_function

  # Finds a vector beginning from the starting point
  def find
    find_from_point @starting_point
  end
  def find_from_point point
    @current_point = point
    until made_it?
      candidates = get_sorted_adjacent_points
      until candidates.peek.nil? || made_it?
        find_from_point candidates.next
      end
    end
    # If we've made it, return it. Otherwise return nil.
    if made_it?
      @current_point
    else
      nil
    end
  end
  def calculate_cost candidates
    candidates.map {|x| cost_function x}
  end
  def made_it?
    current_cost < @delta
  end
  def cost_function *args
    @cost_function.call(*args)
  end
  def current_cost
    cost_function @current_point
  end
  def get_adjacent_points *args
    @adjacent_points_function.call(@current_point, *args)
  end
  def get_sorted_adjacent_points *args
    get_adjacent_points(*args).sort_by {|x| cost_function x}.to_enum
  end
end

