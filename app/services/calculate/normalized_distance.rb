class Calculate::NormalizedDistance
  # This turns data set between 0,256, and returns it, inverted, between 0,100.
  # eg. 256 becomes 0, 0 becomes 100, 128 becomes 50.
  def self.call(n, max_dist: 256)
    norm_dist = n.to_f / max_dist
    invert_dist = 1 - norm_dist
    (invert_dist * 100).round(2)
  end
end