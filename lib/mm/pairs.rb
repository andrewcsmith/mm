module MM
  class Pairs
    def linear vector
      vector.each_cons(2).to_a
    end
    def combinatorial vector
      vector.combination(2).to_a
    end
  end
end

