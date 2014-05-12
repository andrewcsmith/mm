module MM
  SCALING_FUNCTIONS = {
    :none => ->(diffs, size) {diffs.inject(0, :+).to_f / size}
  }
end

