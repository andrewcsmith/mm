module MM
  class Deltas
    def self.abs n, m
      (n - m).abs
    end
    def self.direction n, m
      n <=> m
    end
  end
end

