module MM; end

# All you need to do is add an adjacent_points_function and cost_function
class MM::Search
  attr_accessor :candidates, :delta, :starting_point, :path, :banned, :iterations
  attr_writer :cost_function, :adjacent_points_function

  def initialize starting_point, delta = 0.001
    @starting_point = starting_point
    @delta = delta
    @current_point = @starting_point
    @path = []
    @banned = []
    @iterations = 0
  end

  # Finds a vector beginning from the starting point
  def find
    find_from_point @starting_point
  end

  def find_from_point point
    @iterations += 1
    # The adjacent points are all sorted
    # raise StopIteration if cost_function(point) > current_cost
    add_to_path point
    sorted_adjacent_points = get_sorted_adjacent_points
    # If we've made it, return it.
    if made_it?
      @current_point
    else
      begin
        find_from_point sorted_adjacent_points.next
      rescue StopIteration => er
        # When the list of adjacent points runs out, backtrack
        backtrack
        retry unless @current_point.nil?
      end
    end
  end

  def add_to_path point
    @current_point = point
    @path << point
  end

  def backtrack
    @banned << @path.pop
    puts "Path: #{@path.size}, Banned: #{@banned.size}" if ENV["DEBUG_RB"] && ENV["DEBUG_RB"].to_i > 1
    @current_point = @path.last
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
    get_adjacent_points(*args)
      .reject {|c| @path.include? c}
      .reject {|c| @banned.include? c}
      .sort_by {|x| cost_function x}
      .to_enum
  end
end

