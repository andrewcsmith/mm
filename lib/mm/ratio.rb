require 'yaml'

module MM; end

class MM::Ratio
  def initialize n, d
    gcd = n.gcd d
    @numerator = n / gcd
    @denominator = d / gcd
  end
  attr_accessor :numerator, :denominator
  def / other
    MM::Ratio.new(self.numerator * other.denominator, self.denominator * other.numerator)
  end
  def * other
    MM::Ratio.new(self.numerator * other.numerator, self.denominator * other.denominator)
  end
  def == other
    self.numerator == other.numerator && self.denominator == other.denominator
  end
  def self.from_s r
    if r.respond_to? :match
      m = r.match(/(\d)\/(\d)/)
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
  def reciprocal
    MM::Ratio.new(@denominator, @numerator)
  end
end

