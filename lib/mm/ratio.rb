require 'yaml'
require 'prime'

module MM; end

class MM::Ratio
  include Comparable

  def initialize n, d
    gcd = n.gcd d
    @numerator = n / gcd
    @denominator = d / gcd
  end

  attr_accessor :numerator, :denominator

  def * other
    MM::Ratio.new(self.numerator * other.numerator, self.denominator * other.denominator)
  end

  def / other
    self * other.reciprocal
  end

  def + other
    MM::Ratio.new(self.numerator*other.denominator + other.numerator*self.denominator,
                  self.denominator*other.denominator)
  end

  def - other
    self + (other * MM::Ratio.new(-1,1))
  end

  # Works very similarly to the Prime::prime_division method, except that
  # factors in the numerator are positive, and factors in the denominator are
  # negative.
  def factors
    n_factors = ::Prime.prime_division(@numerator)
    d_factors = ::Prime.prime_division(@denominator).map {|d| d[1] *= -1; d}
    n_factors.concat(d_factors).sort_by {|x| x[0]}
  end

  def abs
    if self < MM::Ratio.new(0, 1)
      self * MM::Ratio.new(-1,1)
    else
      self
    end
  end

  def <=> other
    # Ensure that the comparison makes sense
    return nil unless other.respond_to? :-

    case
    when (self - other).to_f > 0
      return 1
    when (self - other).to_f < 0
      return -1
    end
    return 0
  end

  def self.from_s r
    if r.respond_to? :split
      if r =~ /\s/
        r.split(/\s/).inject([]) {|memo, ratio|
          memo << self.from_s(ratio)
        }
      else
        string_to_ratio r
      end
    else
      r.map {|s| self.from_s s}
    end
  end

  def self.string_to_ratio string
    m = string.match(/(\d+)\/(\d+)/)
    MM::Ratio.new(m[1].to_i, m[2].to_i)
  end

  # Loads a sequence of MM::Ratios from a YAML file.
  def self.from_yaml yaml_string
    YAML.load(yaml_string).map {|r| MM::Ratio.from_s r}
  end

  def to_f
    @numerator.to_f / @denominator
  end

  def to_s
    "#{@numerator}/#{@denominator}"
  end

  def reciprocal
    MM::Ratio.new(@denominator, @numerator)
  end

  def self.to_vector point
    point.each_cons(2).map {|r| r[0] / r[1]}
  end

  def self.from_vector vector
    vector.inject([MM::Ratio.new(1,1)]) {|m, r| m << (m.last / r)}
  end

  def self.change_interval point, index, interval
    vector = MM::Ratio.to_vector(point)
    if interval == :reciprocal
      interval = vector[index].reciprocal
    end
    vector[index] = interval
    MM::Ratio.from_vector(vector)
  end
end

