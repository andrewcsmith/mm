module MM
  module Deltas
    def self.abs n
      (n[0] - n[1]).abs
    end
    def self.mean n
      n.inject(0.0, :+) / n.size
    end
    # Have to scale by 0.5 in order to normalize to a max distance of 1.0
    def self.direction n
      (n[0] <=> n[1]) * 0.5
    end
    # Accepts a tuple where the quotient responds to #numerator and #denominator
    def self.tenney n
      ->(r) { Math.log2(r.numerator * r.denominator) }.call(n[0] / n[1])
    end
    # Accepts a tuple of anything that Math.log2 can handle
    def self.log_ratio n
      Math.log2(n[0] / n[1]).abs
    end
  end
end

