module MM
  module Scaling
    # All of these functions require a sequence of distance pair evaluations of
    # the given metric. They all output scaled versions.

    # Scale to the max across both vector
    def self.none pairs
      pairs
    end
    def self.absolute pairs
      max = (pairs.map(&:max)).max
      pairs.map {|x| x.map {|y| y.to_f / max}}
    end
    # Scale each vector to its own max
    def self.relative pairs
      maxes = pairs.map(&:max)
      pairs.zip(maxes).map {|pair, max| pair.map {|x| x.to_f / max}}
    end
  end
end

