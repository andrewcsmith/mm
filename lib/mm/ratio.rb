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
  def == other
    self.numerator == other.numerator && self.denominator == other.denominator
  end
end

