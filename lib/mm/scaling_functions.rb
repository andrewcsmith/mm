module MM
  SCALING_FUNCTIONS = {
    :none => ->(pairs) {
      pairs
    },
    :absolute => ->(pairs) {
      max = (pairs.map &:max).max
      pairs.map {|x| x.map {|y| y.to_f / max}}
    },
    :relative => ->(pairs) {
      maxes = pairs.map(&:max)
      pairs.zip(maxes).map {|pair, max| pair.map {|x| x.to_f / max}}
    }
  }
end

