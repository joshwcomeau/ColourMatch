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

  def self.z_score(a, sample, m=nil, d=nil)
    # Calculate mean and deviation unless provided
    m ||= mean(sample)
    d ||= standard_deviation(sample) 

    (a - m) / d
  end
end