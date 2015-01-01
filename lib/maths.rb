module Maths
  def self.sum(a)
    a.inject(0){ |accum, i| accum + i }
  end

  def self.mean(a)
    sum(a) / a.length.to_f
  end

  def self.sample_variance(a)
    m = mean(a)
    sum = a.inject(0){ |accum, i| accum + (i - m) ** 2 }
    sum / (a.length - 1).to_f
  end

  def self.standard_deviation(a)
    Math.sqrt(sample_variance(a))
  end

  def self.z_score(a, sample: nil, mean: nil, deviation: nil)
    raise "Need either the sample, or the mean and deviation, to calculate z-score" unless sample || (mean && deviation)
    # Calculate mean and deviation unless provided
    mean      ||= mean(sample)
    deviation ||= standard_deviation(sample) 

    (a - mean) / deviation
  end
end