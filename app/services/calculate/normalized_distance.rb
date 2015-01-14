class Calculate::NormalizedDistance
  # This turns data set between 0,150, and returns it, inverted, between 0,100.
  # eg. 150 becomes 0, 0 becomes 100, 75 becomes 50.

  def self.call(n, max_dist: 100)
    # NOTE: The REAL max dist is 256. However, they aren't linearly arranged, almost no real photos
    # are above 100. We shouldn't run into many 0-scores by lowering the max to 150, and really it
    # doesn't matter since we aren't even showing photos below a certain match threshold.
    n = max_dist if n > max_dist

    norm_dist = n.to_f / max_dist
    invert_dist = 1 - norm_dist
    (invert_dist * 100).round(2)
  end
end