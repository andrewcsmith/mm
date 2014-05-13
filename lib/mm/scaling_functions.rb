module MM
  module Scaling
    def self.none pairs
      pairs
    end
    def self.absolute pairs
      max = (pairs.map &:max).max
      pairs.map {|x| x.map {|y| y.to_f / max}}
    end
    def self.relative pairs
      maxes = pairs.map(&:max)
      pairs.zip(maxes).map {|pair, max| pair.map {|x| x.to_f / max}}
    end
  end
end

