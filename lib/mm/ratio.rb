require 'yaml'

module MM; end

class MM::Ratio
  include Comparable

  def initialize n, d
    gcd = n.gcd d
    @numerator = n / gcd
    @denominator = d / gcd
  end

  attr_accessor :numerator, :denominator

  def / other
    self * other.reciprocal
  end

  def * other
    MM::Ratio.new(self.numerator * other.numerator, self.denominator * other.denominator)
  end

  def + other
    MM::Ratio.new(self.numerator*other.denominator + other.numerator*self.denominator,
                  self.denominator*other.denominator)
  end

  def - other
    MM::Ratio.new(self.numerator*other.denominator - other.numerator*self.denominator,
                  self.denominator*other.denominator)
  end

  def abs
    if self < MM::Ratio.new(0, 1)
      self * MM::Ratio.new(-1,1)
    else
      self
    end
  end

  def <=> other
    case
    when (self - other).to_f > 0
      return 1
    when (self - other).to_f < 0
      return -1
    end
    return 0
  end

#  def == other
#    self.numerator == other.numerator && self.denominator == other.denominator
#  end

  def self.from_s r
    if r.respond_to? :match
      m = r.match(/(\d+)\/(\d+)/)
      MM::Ratio.new(m[1].to_i, m[2].to_i)
    else
      r.map {|s| self.from_s s}
    end
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
    vector[index] = interval
    MM::Ratio.from_vector(vector)
  end
end

