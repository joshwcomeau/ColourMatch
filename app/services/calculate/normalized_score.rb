class Calculate::NormalizedScore
  # This turns data set between 0,256*length, and returns it, inverted, between 0,100.
  def self.call(val, length, max_dist: 256)
    norm_dist = val.to_f / (max_dist * length)
    invert_dist = 1 - norm_dist
    (invert_dist * 100)
  end
end