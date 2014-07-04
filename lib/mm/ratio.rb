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
  def self.from_s r
    if r.respond_to? :match
      m = r.match(/(\d)\/(\d)/)
      MM::Ratio.new(m[1].to_i, m[2].to_i)
    else
      r.map {|s| self.from_s s}
    end
  end
end

