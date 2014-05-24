module MM
  class Deltas
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
  end
end

